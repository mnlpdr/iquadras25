Rails.application.routes.draw do
  # Configuração do Devise para autenticação
  devise_for :users

  # Página inicial
  root "home#index"
  get "home/index", as: :home

  # Rotas para Quadras (agora permite criar, editar e excluir)
  resources :courts

  # Rotas para Reservas
  resources :reservations, only: [:index, :new, :create, :destroy]

  # Rota de Health Check
  get "up" => "rails/health#show", as: :rails_health_check
end
