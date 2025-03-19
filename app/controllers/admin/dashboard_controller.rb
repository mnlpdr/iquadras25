module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin
    
    def index
      @stats = {
        queues: Sidekiq::Stats.new.queues,
        processed: Sidekiq::Stats.new.processed,
        failed: Sidekiq::Stats.new.failed,
        scheduled: Sidekiq::Stats.new.scheduled_size,
        retries: Sidekiq::RetrySet.new.size,
        dead: Sidekiq::DeadSet.new.size
      }
      
      @notification_logs = NotificationLog.order(created_at: :desc).limit(10)
    end
    
    private
    
    def authorize_admin
      redirect_to root_path, alert: "Acesso negado!" unless current_user.admin?
    end
  end
end 