class RefundService
  def self.process_refund(payment)
    # Em um sistema real, aqui você chamaria a API do seu gateway de pagamento
    # para processar o reembolso
    
    Rails.logger.info("Processando reembolso para pagamento ##{payment.id}")
    
    # Simulação de processamento de reembolso
    success = rand > 0.1 # 90% de chance de sucesso
    
    if success
      payment.update(status: :refunded)
      Rails.logger.info("Reembolso processado com sucesso para pagamento ##{payment.id}")
      
      # Notificar o usuário sobre o reembolso
      NotificationService.notify_payment_refunded(payment)
      
      return { success: true }
    else
      error_message = "Falha no processamento do reembolso"
      Rails.logger.error("#{error_message} para pagamento ##{payment.id}")
      
      return { success: false, error: error_message }
    end
  end
end 