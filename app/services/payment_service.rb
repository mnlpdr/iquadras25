# Stub para o serviço de pagamento
module PaymentService
  class << self
    def configure
      yield self if block_given?
    end
    
    def method_missing(method, *args, &block)
      Rails.logger.warn "PaymentService: Chamada para método não implementado: #{method}"
      nil
    end
    
    def respond_to_missing?(method_name, include_private = false)
      true
    end
  end
end 