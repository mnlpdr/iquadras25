# class CourtOwnersController < ApplicationController
#   before_action :authenticate_user!
#   before_action :authorize_admin
#   before_action :set_court_owner, only: [:show, :edit, :update, :destroy]

#   def index
#     @court_owners = User.where(role: :court_owner)
#   end

#   def show
#   end

#   def new
#     @court_owner = User.new(role: :court_owner) # Garante que novos usuários criados aqui sejam donos de quadra
#   end

#   def create
#     @court_owner = User.new(court_owner_params)
#     @court_owner.role = :court_owner

#     if @court_owner.save
#       redirect_to court_owners_path, notice: "Dono de quadra criado com sucesso!"
#     else
#       flash.now[:alert] = @court_owner.errors.full_messages.join(", ")
#       render :new, status: :unprocessable_entity
#     end
#   end

#   def edit
#   end

#   def update
#     if @court_owner.update(court_owner_params)
#       redirect_to court_owners_path, notice: "Dono de quadra atualizado com sucesso!"
#     else
#       flash.now[:alert] = @court_owner.errors.full_messages.join(", ")
#       render :edit, status: :unprocessable_entity
#     end
#   end

#   def destroy
#     if @court_owner.destroy
#       redirect_to court_owners_path, notice: "Dono de quadra removido com sucesso."
#     else
#       redirect_to court_owners_path, alert: "Erro ao excluir dono de quadra. Ele pode ter registros associados."
#     end
#   end

#   private

#   def set_court_owner
#     @court_owner = User.find_by(id: params[:id])
    
#     if @court_owner.nil?
#       redirect_to court_owners_path, alert: "Dono de quadra não encontrado."
#     end
#   end

#   def court_owner_params
#     params.require(:user).permit(:name, :email, :password, :password_confirmation)
#   end

#   def authorize_admin
#     redirect_to root_path, alert: "Acesso negado!" unless current_user.admin?
#   end
# end
