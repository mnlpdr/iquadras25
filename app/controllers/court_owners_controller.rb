class CourtOwnersController < ApplicationController
  before_action :set_court_owner, only: %i[show edit update destroy]

  def index
    @court_owners = CourtOwner.all
  end

  def show
  end

  def new
    @court_owner = CourtOwner.new
  end

  def create
    @court_owner = CourtOwner.new(court_owner_params)
    if @court_owner.save
      redirect_to @court_owner, notice: "Dono de Quadra cadastrado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @court_owner.update(court_owner_params)
      redirect_to @court_owner, notice: "Dados do Dono de Quadra atualizados!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @court_owner.destroy
    redirect_to court_owners_url, notice: "Dono de Quadra removido."
  end

  private

  def set_court_owner
    @court_owner = CourtOwner.find(params[:id])
  end

  def court_owner_params
    params.require(:court_owner).permit(:name, :email, :phone_number, :address, :password, :password_confirmation)
  end
end
