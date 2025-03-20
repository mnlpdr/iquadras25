module RatingsHelper
    def display_court_rating(court_id)
      begin
        rating_data = RatingsServiceClient.get_court_average_rating(court_id)
        
        if rating_data[:total_ratings] > 0
          render partial: 'shared/court_rating', locals: { 
            rating: rating_data[:average_rating], 
            count: rating_data[:total_ratings]
          }
        else
          content_tag(:span, "Sem avaliações", class: "text-muted")
        end
      rescue RatingsServiceClient::RatingsServiceError => e
        Rails.logger.error("Erro ao buscar avaliação: #{e.message}")
        content_tag(:span, "Avaliações indisponíveis", class: "text-muted")
      end
    end
  end