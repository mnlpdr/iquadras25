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
    @court = current_user.courts.build(court_params)
    
    respond_to do |format|
      if @court.save
        format.html { redirect_to @court, notice: 'Quadra criada com sucesso.' }
        format.json { render :show, status: :created, location: @court }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @court.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @court.update(court_params)
        format.html { redirect_to @court, notice: 'Quadra atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @court }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @court.errors, status: :unprocessable_entity }
      end
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
    params.require(:court).permit(:name, :location, :capacity, :price_per_hour, :owner_id, :photo, sport_ids: [])
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
