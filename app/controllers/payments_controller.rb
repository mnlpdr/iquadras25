class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:new, :create]
  skip_before_action :verify_authenticity_token, only: [:webhook]
  
  def new
    # Verifica se a reserva já tem um pagamento pendente
    if @reservation.payment&.pending?
      @payment = @reservation.payment
      @client_secret = @payment.metadata["client_secret"]
    else
      # Cria um novo payment intent
      result = StripeService.create_payment_intent(@reservation)
      
      if result[:success]
        @payment = result[:payment]
        @client_secret = result[:client_secret]
        
        # Notificar sobre a criação do pagamento
        NotificationService.notify_payment_created(@payment)
      else
        redirect_to reservation_path(@reservation), alert: result[:error]
        return
      end
    end
  end
  
  def create
    # Este endpoint é chamado pelo formulário após o pagamento ser simulado
    payment_intent_id = params[:payment_intent_id]
    result = StripeService.confirm_payment(payment_intent_id)
    
    if result[:success]
      # Notificar sobre a confirmação do pagamento
      NotificationService.notify_payment_completed(result[:payment])
      redirect_to reservation_path(@reservation), notice: "Pagamento confirmado com sucesso!"
    else
      # Notificar sobre a falha do pagamento
      payment = Payment.find_by(stripe_payment_intent_id: payment_intent_id.split('_secret_').first)
      NotificationService.notify_payment_failed(payment, result[:error]) if payment
      
      redirect_to new_reservation_payment_path(@reservation), alert: result[:error]
    end
  end
  
  def webhook
    # Implementação do webhook do Stripe (não necessário para simulação)
    render json: { received: true }
  end
  
  private
  
  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
    authorize! :read, @reservation
  end
end
