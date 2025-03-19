class CourtsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_court, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin_or_owner, only: [:edit, :update, :destroy]
  before_action :set_sports, only: [:index, :new, :edit, :create, :update]

  def index
    base_query = if current_user.admin?
      Court.all
    elsif current_user.court_owner?
      current_user.courts
    else
      Court.all
    end

    @courts = base_query.by_sport(params[:sport_id])
  end

  def show
  end

  def new
    if current_user.admin? || current_user.court_owner?
      @court = Court.new
    else
      redirect_to courts_path, alert: "Acesso negado!"
    end
  end

  def create
    @court = Court.new(court_params)
    
    # Se for admin, precisamos definir o dono da quadra
    if current_user.admin?
      owner = User.court_owner.find_by(id: params[:court][:owner_id])
      @court.owner = owner if owner
    else
      @court.owner = current_user
    end

    if @court.save
      NotificationService.notify_court_created(@court)
      redirect_to courts_path, notice: "Quadra criada com sucesso!"
    else
      flash.now[:alert] = @court.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @court.update(court_params)
      NotificationService.notify_court_updated(@court)
      redirect_to courts_path, notice: "Quadra atualizada com sucesso!"
    else
      flash.now[:alert] = @court.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.admin? || (current_user.court_owner? && @court.owner == current_user)
      NotificationService.notify_court_deleted(@court)
      @court.destroy
      redirect_to courts_path, notice: "Quadra removida com sucesso!"
    else
      redirect_to courts_path, alert: "Você não tem permissão para excluir esta quadra."
    end
  end
  



  private

  def set_court
    @court = Court.find(params[:id])
  end

  def court_params
    permitted_params = if current_user.admin?
      params.require(:court).permit(:name, :location, :capacity, :price_per_hour, :owner_id, sport_ids: [])
    else
      params.require(:court).permit(:name, :location, :capacity, :price_per_hour, sport_ids: [])
    end
  end

  def authorize_admin_or_owner
    unless current_user.admin? || (current_user.court_owner? && current_user == @court.owner)
      redirect_to courts_path, alert: "Acesso negado!"
    end
  end

  def set_sports
    @sports = Sport.all
  end
end
