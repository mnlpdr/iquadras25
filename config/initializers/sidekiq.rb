require_relative 'resilient_redis'

Sidekiq.configure_server do |config|
  # Obtém o servidor atual e configura diretamente (sem usar lambda)
  server = ResilientRedis::ConnectionManager.current_server
  config.redis = { url: "redis://#{server[:host]}:#{server[:port]}/0" }
  
  # Adiciona um handler para tentar reconectar em caso de erro
  config.error_handlers << proc do |ex, ctx|
    if ex.is_a?(Redis::BaseError)
      Rails.logger.warn "Sidekiq encontrou erro Redis: #{ex.message}. Tentando reconectar..."
      next_server = ResilientRedis::ConnectionManager.next_server
      Sidekiq.redis = { url: "redis://#{next_server[:host]}:#{next_server[:port]}/0" }
    end
  end
end

Sidekiq.configure_client do |config|
  # Obtém o servidor atual e configura diretamente (sem usar lambda)
  server = ResilientRedis::ConnectionManager.current_server
  config.redis = { url: "redis://#{server[:host]}:#{server[:port]}/0" }
end 