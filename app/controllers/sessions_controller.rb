# pra gerenciar as sessoes de login dos clientess
class SessionsController < ApplicationController
    def new
      @client = Client.new
    end
  
    def create
      @client = Client.find_by(email: params[:email])
      if @client&.authenticate(params[:password])
        session[:client_id] = @client.id
        redirect_to root_path, notice: "Bem-vindo, #{@client.email}!"
      else
        flash.now[:alert] = "Email ou senha inválidos."
        render :new
      end
    end
  
    def destroy
      session[:client_id] = nil
      redirect_to root_path, notice: "Você saiu com sucesso."
    end
  end
  