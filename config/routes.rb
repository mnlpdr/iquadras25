require 'sidekiq/web'

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
  resources :reservations, only: [:index, :new, :create, :show, :destroy] do
    collection do
      get 'available_slots'
    end
    resources :payments, only: [:new, :create]
  end

  # Área administrativa
  namespace :admin do
    resources :clients, controller: 'users', defaults: { role: 'client' }
    resources :court_owners, controller: 'users', defaults: { role: 'court_owner' }
    resources :courts, only: [:destroy]
    resources :reservations
    resources :notification_logs, only: [:index, :show]
    get 'dashboard', to: 'dashboard#index'
  end

  # Rota de Health Check
  get "up" => "rails/health#show", as: :rails_health_check

  # Adicione isso antes das outras rotas
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get "health" => "health#check"

  # Rota para webhooks do Stripe
  post 'stripe/webhook', to: 'payments#webhook'

  # Montar o Bulletin Board
  mount BulletinBoard::Engine, at: '/bulletin_board'
end
