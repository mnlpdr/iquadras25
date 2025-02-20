module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      @users = User.where(role: params[:role])
    end

    def show
    end

    def new
      @user = User.new(role: params[:role])
    end

    def create
      @user = User.new(user_params)
      @user.role = params[:role]

      if @user.save
        redirect_to(
          params[:role] == "client" ? admin_clients_path : admin_court_owners_path,
          notice: "#{params[:role].titleize} criado com sucesso!"
        )
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to(
          params[:role] == "client" ? admin_clients_path : admin_court_owners_path,
          notice: "#{params[:role].titleize} atualizado com sucesso!"
        )
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user.destroy
        redirect_to(
          params[:role] == "client" ? admin_clients_path : admin_court_owners_path,
          notice: "#{params[:role].titleize} removido com sucesso!"
        )
      else
        redirect_to(
          params[:role] == "client" ? admin_clients_path : admin_court_owners_path,
          alert: "Erro ao excluir. Pode haver registros associados."
        )
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone_number)
    end

    def authorize_admin
      redirect_to root_path, alert: "Acesso negado!" unless current_user.admin?
    end
  end
end