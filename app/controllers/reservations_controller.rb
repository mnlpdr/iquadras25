class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:destroy]
  load_and_authorize_resource except: [:create, :available_slots]

  def index
    @reservations = case current_user.role
                   when 'admin'
                     Reservation.includes(:user, :court)
                              .order(date: :asc, start_time: :asc)
                   when 'court_owner'
                     Reservation.includes(:user, :court)
                              .joins(:court)
                              .where(courts: { owner_id: current_user.id })
                              .order(date: :asc, start_time: :asc)
                   else # client
                     current_user.reservations.includes(:court)
                              .order(date: :asc, start_time: :asc)
                   end
  end

  def new
    @reservation = Reservation.new
    @reservation.court_id = params[:court_id] if params[:court_id]
    @reservation.user = current_user
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)
    
    if params[:reservation][:time_slot].present?
      start_time, end_time = params[:reservation][:time_slot].split('-')
      date = Date.parse(params[:reservation][:date])
      @reservation.start_time = Time.zone.parse("#{date} #{start_time}")
      @reservation.end_time = Time.zone.parse("#{date} #{end_time}")
    end

    if @reservation.save
      redirect_to reservations_path, notice: "Reserva criada com sucesso!"
    else
      flash.now[:alert] = @reservation.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @reservation.destroy
      redirect_to reservations_path, notice: "Reserva cancelada com sucesso!"
    else
      redirect_to reservations_path, alert: "Erro ao cancelar a reserva."
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

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:court_id, :date)
  end
end
