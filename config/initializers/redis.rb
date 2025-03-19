=begin
require 'redis'
require 'redis/distributed'

# Configuração de múltiplos servidores Redis (principal e réplica)
REDIS_SERVERS = [
  { host: ENV.fetch('REDIS_PRIMARY_HOST', 'localhost'), port: ENV.fetch('REDIS_PRIMARY_PORT', 6379) },
  { host: ENV.fetch('REDIS_REPLICA_HOST', 'localhost'), port: ENV.fetch('REDIS_REPLICA_PORT', 6380) }
]

# Cria um cliente Redis distribuído
$redis = Redis::Distributed.new(REDIS_SERVERS.map { |server| 
  "redis://#{server[:host]}:#{server[:port]}" 
})

# Configuração do Sidekiq para usar o Redis distribuído
Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{REDIS_SERVERS[0][:host]}:#{REDIS_SERVERS[0][:port]}/0" }
  
  # Configuração de fallback
  config.error_handlers << proc do |ex, ctx|
    if ex.is_a?(Redis::CannotConnectError)
      # Tenta conectar ao servidor de backup
      Sidekiq.redis = { url: "redis://#{REDIS_SERVERS[1][:host]}:#{REDIS_SERVERS[1][:port]}/0" }
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{REDIS_SERVERS[0][:host]}:#{REDIS_SERVERS[0][:port]}/0" }
end 
=end