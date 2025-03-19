module Admin
  class NotificationLogsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin

    def index
      @notification_logs = NotificationLog.order(created_at: :desc).page(params[:page]).per(20)
    end

    def show
      @notification_log = NotificationLog.find(params[:id])
    end

    private

    def authorize_admin
      redirect_to root_path, alert: "Acesso negado!" unless current_user.admin?
    end
  end
end 