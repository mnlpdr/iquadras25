Rails.application.routes.draw do
  # Configuração do Devise para autenticação
  devise_for :users, controllers: { registrations: "registrations" }
  
  # Rota específica para registro de dono de quadra
  devise_scope :user do
    get '/court_owners/sign_up', to: 'registrations#new_court_owner', as: :new_court_owner_registration
  end

  # Página inicial
  root "home#index"

  # Rotas para Quadras
  resources :courts
  resources :reservations, only: [:index, :new, :create, :destroy] do
    collection do
      get 'available_slots'
    end
  end

  # Área administrativa
  namespace :admin do
    resources :clients, controller: 'users', defaults: { role: 'client' }
    resources :court_owners, controller: 'users', defaults: { role: 'court_owner' }
    resources :courts, only: [:destroy]
    resources :reservations
  end

  # Rota de Health Check
  get "up" => "rails/health#show", as: :rails_health_check
end
