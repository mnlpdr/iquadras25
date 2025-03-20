class RatingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_rating, only: [:edit, :update, :destroy]
    rescue_from RatingsServiceClient::RatingsServiceError, with: :handle_ratings_service_error
  
    def index
      @ratings = RatingsServiceClient.get_court_ratings(params[:court_id])
    end
  
    def new
      @court = Court.find(params[:court_id])
      # Verificar se o usuário já avaliou esta quadra
      user_ratings = RatingsServiceClient.get_user_ratings(current_user.id)
      existing_rating = user_ratings.find { |r| r[:court_id] == @court.id }
      
      if existing_rating
        redirect_to edit_rating_path(existing_rating[:id]), notice: "Você já avaliou esta quadra. Você pode editar sua avaliação."
        return
      end
    end
  
    def create
      court = Court.find(params[:rating][:court_id])
      
      begin
        result = RatingsServiceClient.create_rating(
          court_id: court.id,
          user_id: current_user.id,
          score: params[:rating][:score],
          comment: params[:rating][:comment]
        )
        
        redirect_to court_path(court), notice: "Avaliação enviada com sucesso!"
      rescue RatingsServiceClient::RatingsServiceError => e
        @court = court
        flash.now[:alert] = e.message
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
      @court = Court.find_by(id: @rating[:court_id])
      
      # Verificar se o usuário é o dono da avaliação
      unless @rating[:user_id] == current_user.id
        redirect_to courts_path, alert: "Você não tem permissão para editar esta avaliação"
        return
      end
    end
  
    def update
      if RatingsServiceClient.update_rating(
        id: params[:id],
        score: params[:rating][:score],
        comment: params[:rating][:comment]
      )
        redirect_to court_path(@rating[:court_id]), notice: "Avaliação atualizada com sucesso!"
      else
        @court = Court.find_by(id: @rating[:court_id])
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      court_id = @rating[:court_id]
      
      # Verificar se o usuário é o dono da avaliação
      unless @rating[:user_id] == current_user.id
        redirect_to courts_path, alert: "Você não tem permissão para excluir esta avaliação"
        return
      end
      
      if RatingsServiceClient.delete_rating(params[:id])
        redirect_to court_path(court_id), notice: "Avaliação excluída com sucesso!"
      else
        redirect_to court_path(court_id), alert: "Erro ao excluir avaliação"
      end
    end
  
    private
  
    def set_rating
      @rating = RatingsServiceClient.get_court_ratings(nil).find { |r| r[:id].to_s == params[:id].to_s }
      
      unless @rating
        redirect_to courts_path, alert: "Avaliação não encontrada"
        return
      end
    end
  
    def handle_ratings_service_error(error)
      Rails.logger.error("Erro no serviço de avaliações: #{error.message}")
      redirect_to courts_path, alert: "O serviço de avaliações está temporariamente indisponível. Tente novamente mais tarde."
    end
  end