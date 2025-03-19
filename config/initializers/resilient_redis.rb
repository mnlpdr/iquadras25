require 'redis'

module ResilientRedis
  class ConnectionManager
    def self.servers
      @servers ||= [
        { host: ENV.fetch('REDIS_PRIMARY_HOST', 'localhost'), port: ENV.fetch('REDIS_PRIMARY_PORT', 6379) },
        { host: ENV.fetch('REDIS_REPLICA_HOST', 'localhost'), port: ENV.fetch('REDIS_REPLICA_PORT', 6380) }
      ]
    end

    def self.current_server_index
      @current_server_index ||= 0
    end

    def self.current_server_index=(index)
      @current_server_index = index
    end

    def self.current_server
      servers[current_server_index]
    end

    def self.next_server
      self.current_server_index = (current_server_index + 1) % servers.size
      current_server
    end

    def self.get_connection(options = {})
      retries = options.fetch(:retries, servers.size)
      timeout = options.fetch(:timeout, 1)
      
      begin
        server = current_server
        Rails.logger.info "Tentando conectar ao Redis #{server[:host]}:#{server[:port]}"
        redis = Redis.new(host: server[:host], port: server[:port], timeout: timeout)
        redis.ping  # Verifica se a conexão está ativa
        return redis
      rescue Redis::BaseError => e
        Rails.logger.warn "Falha ao conectar ao Redis #{server[:host]}:#{server[:port]}: #{e.message}"
        retries -= 1
        
        if retries > 0
          server = next_server
          Rails.logger.info "Tentando servidor alternativo: #{server[:host]}:#{server[:port]}"
          retry
        else
          Rails.logger.error "Não foi possível conectar a nenhum servidor Redis"
          raise e
        end
      end
    end

    def self.with_connection(options = {})
      max_attempts = options.fetch(:max_attempts, 3)
      attempt = 0
      
      begin
        attempt += 1
        connection = get_connection(options)
        yield connection
      rescue Redis::BaseError => e
        if attempt < max_attempts
          Rails.logger.warn "Erro na operação Redis (tentativa #{attempt}/#{max_attempts}): #{e.message}"
          sleep 0.5
          retry
        else
          Rails.logger.error "Falha após #{max_attempts} tentativas: #{e.message}"
          raise e
        end
      end
    end
    
    # Método para operações de leitura/escrita com fallback
    def self.safe_operation(operation, *args)
      begin
        with_connection do |redis|
          redis.send(operation, *args)
        end
      rescue Redis::BaseError => e
        Rails.logger.error "Operação Redis '#{operation}' falhou: #{e.message}"
        nil  # Retorna nil em caso de falha
      end
    end
  end
end

# Cria um proxy global para operações Redis
$redis = Object.new

# Define métodos para encaminhar chamadas para o gerenciador resiliente
Redis.public_instance_methods(false).each do |method_name|
  next if method_name =~ /^(__|instance_eval|class|object_id)/
  
  $redis.define_singleton_method(method_name) do |*args, &block|
    ResilientRedis::ConnectionManager.safe_operation(method_name, *args, &block)
  end
end 