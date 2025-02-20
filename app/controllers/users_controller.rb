class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: %i[show edit update destroy]
    load_and_authorize_resource
  
    def index
      @users = User.all
    end
  
    def show
    end
  
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
  
      if @user.save
        redirect_to users_path, notice: "Usuário criado com sucesso!"
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update
      if @user.update(user_params)
        redirect_to users_path, notice: "Usuário atualizado com sucesso!"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @user.destroy
      redirect_to users_path, notice: "Usuário removido com sucesso!"
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    end
  end
  