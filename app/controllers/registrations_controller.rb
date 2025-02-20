class RegistrationsController < Devise::RegistrationsController
    def new
      @user = User.new(role: "client")
      super
    end
  
    def new_court_owner
      @user = User.new(role: "court_owner")
      render :new
    end
  
    def create
      super
    end
  
    protected
  
    # Permitir que o Devise aceite `name` e `role` no cadastro
    def sign_up_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    end
  end
  