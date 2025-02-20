class ReservationsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @reservations = Reservation.all
  end
  
  def new
    @reservation = Reservation.new
    @courts = Court.all # Carregar todas as quadras disponíveis
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user = current_user
    @courts = Court.all
    
    court = @reservation.court
    start_time = @reservation.start_time
    end_time = @reservation.end_time
    date = @reservation.date
  
    # Validar se a reserva está dentro do horário de funcionamento da quadra
    if !court.working_hours_range.cover?(start_time) || !court.working_hours_range.cover?(end_time)
      @reservation.errors.add(:base, "A reserva deve estar dentro do horário de funcionamento da quadra.")
      render :new, status: :unprocessable_entity and return
    end
  
    # Verificar se já existe uma reserva no mesmo horário e data para a mesma quadra
    if Reservation.exists?(court_id: court.id, date: date, start_time: start_time..end_time)
      @reservation.errors.add(:base, "Já existe uma reserva no mesmo horário para essa quadra.")
      render :new, status: :unprocessable_entity and return
    end
  
    # Salvar a reserva
    if @reservation.save
      redirect_to reservations_path, notice: "Reserva criada com sucesso!"
    else
      render :new
    end
  end
  

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    redirect_to reservations_path, notice: "Reserva removida com sucesso!"
  end
  
  private
  
  def reservation_params
    params.require(:reservation).permit(:court_id, :start_time, :end_time, :date)
  end
end
