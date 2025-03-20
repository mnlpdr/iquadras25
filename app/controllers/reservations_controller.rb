class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:show, :destroy, :cancel]
  load_and_authorize_resource except: [:create, :available_slots]

  def index
    if current_user.admin?
      @reservations = Reservation.includes(:court, :user)
    elsif current_user.court_owner?
      @reservations = Reservation.joins(:court).where(courts: { owner_id: current_user.id })
    else
      @reservations = current_user.reservations
    end
    
    # Aplicar filtro de status
    case params[:status]
    when "active"
      @reservations = @reservations.where.not(status: :cancelled)
    when "cancelled"
      @reservations = @reservations.where(status: :cancelled)
    end
    
    @reservations = @reservations.includes(:court, :user).order(created_at: :desc)
  end

  def show
    # A reserva já é carregada pelo before_action :set_reservation
  end

  def new
    @reservation = Reservation.new
    @reservation.court_id = params[:court_id] if params[:court_id]
    @reservation.user = current_user
  end

  def create
    @reservation = current_user.reservations.new(reservation_params)
    @reservation.status = :pending_payment
    
    # Processar o time_slot do formulário para definir start_time e end_time
    if params[:reservation][:time_slot].present?
      start_time, end_time = params[:reservation][:time_slot].split('-')
      date = Date.parse(params[:reservation][:date])
      @reservation.start_time = Time.zone.parse("#{date} #{start_time}")
      @reservation.end_time = Time.zone.parse("#{date} #{end_time}")
    end

    if @reservation.save
      redirect_to new_reservation_payment_path(@reservation), notice: 'Reserva criada com sucesso. Por favor, realize o pagamento.'
    else
      flash.now[:alert] = @reservation.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # Armazene os dados da reserva antes de cancelá-la para notificações
    reservation_data = {
      id: @reservation.id,
      court_name: @reservation.court.name,
      date: @reservation.date.to_s,
      start_time: @reservation.start_time.strftime('%H:%M'),
      end_time: @reservation.end_time.strftime('%H:%M'),
      user_name: @reservation.user.name,
      user_email: @reservation.user.email
    }

    begin
      # Tente cancelar a reserva
      result = @reservation.safe_cancel
      
      if result
        NotificationService.notify_reservation_cancelled(@reservation)
        redirect_to reservations_path, notice: "Reserva cancelada com sucesso!"
      else
        flash[:alert] = "Não foi possível cancelar a reserva: #{@reservation.errors.full_messages.join(', ')}"
        redirect_to reservation_path(@reservation)
      end
    rescue => e
      Rails.logger.error("Erro ao cancelar reserva: #{e.message}")
      flash[:alert] = "Erro ao processar o cancelamento: #{e.message}"
      redirect_to reservation_path(@reservation)
    end
  end

  def available_slots
    return unless current_user
    
    @court = Court.find(params[:court_id])
    @date = Date.parse(params[:date])
    @slots = helpers.available_time_slots(@date, @court)
    
    Rails.logger.debug "Slots disponíveis: #{@slots.inspect}"
    
    render json: @slots
  rescue StandardError => e
    Rails.logger.error "Erro em available_slots: #{e.message}"
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def cancel
    if @reservation.confirmed? && @reservation.payment&.completed?
      result = StripeService.refund_payment(@reservation.payment)
      
      if result[:success]
        @reservation.update(status: :cancelled)
        redirect_to @reservation, notice: "Reserva cancelada e pagamento reembolsado com sucesso."
      else
        redirect_to @reservation, alert: "Erro ao processar o reembolso."
      end
    else
      redirect_to @reservation, alert: "Esta reserva não pode ser cancelada."
    end
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    # Remova time_slot e date dos parâmetros permitidos, pois eles são processados separadamente
    params.require(:reservation).permit(:court_id)
  end
end
