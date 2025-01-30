class ReservationsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @reservations = Reservation.all
    end
  
    def new
      @reservation = Reservation.new
    end
  
    def create
      Rails.logger.debug "Parâmetros Recebidos: #{params.inspect}"
  
      @reservation = Reservation.new(reservation_params)
      @reservation.user = current_user
  
      if @reservation.save
        Rails.logger.debug "Reserva Criada: #{@reservation.inspect}"
        redirect_to reservations_path, notice: "Reserva criada com sucesso!"
      else
        Rails.logger.debug "Erro ao criar reserva: #{@reservation.errors.full_messages}"
        flash.now[:alert] = @reservation.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity
      end
    end
  
    def destroy
      @reservation = Reservation.find(params[:id])
      @reservation.destroy
      redirect_to reservations_path, notice: "Reserva removida com sucesso!"
    end
  
    private
  
    def reservation_params
      params.require(:reservation).permit(:court_id).merge(
        date: Date.new(
          params[:reservation]["date(1i)"].to_i,
          params[:reservation]["date(2i)"].to_i,
          params[:reservation]["date(3i)"].to_i
        )
      )
    end
  end
  