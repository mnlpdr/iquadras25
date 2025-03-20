module Api
  class PaymentWebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def create
      event_type = params[:event_type]
      payment_data = params[:payment]
      
      case event_type
      when "payment_completed"
        process_payment_completed(payment_data)
      when "payment_refunded"
        process_payment_refunded(payment_data)
      else
        render json: { error: "Evento desconhecido" }, status: :bad_request
        return
      end
      
      render json: { success: true }
    end
    
    private
    
    def process_payment_completed(payment_data)
      reservation = Reservation.find_by(id: payment_data[:reservation_id])
      if reservation
        reservation.update(status: :confirmed)
        NotificationService.notify_payment_completed(OpenStruct.new(payment_data))
      end
    end
    
    def process_payment_refunded(payment_data)
      reservation = Reservation.find_by(id: payment_data[:reservation_id])
      if reservation
        reservation.update(status: :cancelled)
        NotificationService.notify_payment_refunded(OpenStruct.new(payment_data))
      end
    end
  end
end 