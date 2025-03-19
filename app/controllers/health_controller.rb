require 'redis'

class HealthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:check]
  before_action :authorize_admin, only: [:check]
  
  def check
    status = {
      database: database_connected?,
      redis_primary: redis_connected?(redis_servers[0]),
      redis_replica: redis_connected?(redis_servers[1]),
      sidekiq: sidekiq_running?,
      timestamp: Time.current
    }
    
    @health_status = status
    @overall_status = status.values.all? ? "ok" : "degraded"
    
    respond_to do |format|
      format.html # renderiza a view check.html.erb
      format.json do
        if @overall_status == "ok"
          render json: { status: @overall_status, services: status }
        else
          render json: { status: @overall_status, services: status }, status: :service_unavailable
        end
      end
    end
  end
  
  private
  
  def authorize_admin
    unless request.format.json? || (user_signed_in? && current_user.admin?)
      redirect_to root_path, alert: "Acesso negado!"
    end
  end
  
  def database_connected?
    ActiveRecord::Base.connection.active? rescue false
  end
  
  def redis_servers
    ResilientRedis::ConnectionManager.servers
  end
  
  def redis_connected?(server)
    begin
      redis = Redis.new(host: server[:host], port: server[:port], timeout: 1)
      redis.ping == "PONG"
    rescue Redis::BaseError => e
      Rails.logger.warn "Erro ao verificar Redis #{server[:host]}:#{server[:port]}: #{e.message}"
      false
    end
  end
  
  def sidekiq_running?
    begin
      ps = Sidekiq::ProcessSet.new
      !ps.size.zero?
    rescue => e
      Rails.logger.error "Erro ao verificar Sidekiq: #{e.message}"
      false
    end
  end
end 