Rails.application.routes.draw do
  mount RatingsService::Engine => "/ratings_service"
end
