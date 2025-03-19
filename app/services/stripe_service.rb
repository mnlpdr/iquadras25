class StripeService
  def self.create_payment_intent(reservation)
    # Verificar se o preço é válido
    unless reservation.total_price.positive?
      return { success: false, error: "Preço inválido para a reserva" }
    end
    
    # Simulação para testes
    payment_intent_id = "pi_simulated_#{SecureRandom.hex(10)}"
    client_secret = "#{payment_intent_id}_secret_#{SecureRandom.hex(16)}"
    
    payment = Payment.create!(
      reservation: reservation,
      user: reservation.user,
      amount: reservation.total_price,
      status: :pending,
      stripe_payment_intent_id: payment_intent_id,
      metadata: {
        client_secret: client_secret
      }
    )
    
    { success: true, payment: payment, client_secret: client_secret }
  end
  
  def self.confirm_payment(payment_intent_id)
    # Remover o sufixo _secret_xxx se estiver presente
    payment_intent_id = payment_intent_id.split('_secret_').first if payment_intent_id.include?('_secret_')
    
    payment = Payment.find_by(stripe_payment_intent_id: payment_intent_id)
    
    if payment
      payment.update(
        status: :completed,
        stripe_payment_id: "ch_simulated_#{SecureRandom.hex(10)}"
      )
      
      # Atualizar o status da reserva
      payment.reservation.update(status: :confirmed)
      
      { success: true, payment: payment }
    else
      { success: false, error: "Pagamento não encontrado" }
    end
  end
  
  def self.refund_payment(payment)
    refund_id = "re_simulated_#{SecureRandom.hex(10)}"
    
    payment.update(
      status: :refunded,
      metadata: payment.metadata.merge(refund_id: refund_id)
    )
    
    # Notificar sobre o reembolso
    NotificationService.notify_payment_refunded(payment)
    
    { success: true, payment: payment }
  end
end
