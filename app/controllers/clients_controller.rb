# class ClientsController < ApplicationController
#   before_action :authenticate_user!
#   before_action :authorize_admin
#   before_action :set_client, only: [:show, :edit, :update, :destroy]

#   def index
#     @clients = User.where(role: :client)
#   end

#   def show
#   end

#   def new
#     @client = User.new(role: :client) # Garantir que novos usuários criados aqui sejam clientes
#   end

#   def create
#     @client = User.new(client_params)
#     @client.role = :client

#     if @client.save
#       redirect_to clients_path, notice: "Cliente criado com sucesso!"
#     else
#       flash.now[:alert] = @client.errors.full_messages.join(", ")
#       render :new, status: :unprocessable_entity
#     end
#   end

#   def edit
#   end

#   def update
#     if @client.update(client_params)
#       redirect_to clients_path, notice: "Cliente atualizado com sucesso!"
#     else
#       flash.now[:alert] = @client.errors.full_messages.join(", ")
#       render :edit, status: :unprocessable_entity
#     end
#   end

#   def destroy
#     if @client.destroy
#       redirect_to clients_path, notice: "Cliente removido com sucesso."
#     else
#       redirect_to clients_path, alert: "Erro ao excluir cliente. Ele pode ter registros associados."
#     end
#   end

#   private

#   def set_client
#     @client = User.find_by(id: params[:id])
    
#     if @client.nil?
#       redirect_to clients_path, alert: "Cliente não encontrado."
#     end
#   end

#   def client_params
#     params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone_number)
#   end

#   def authorize_admin
#     redirect_to root_path, alert: "Acesso negado!" unless current_user.admin?
#   end
# end
