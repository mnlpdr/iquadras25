Rails.application.routes.draw do
  get "court_owners/index"
  get "court_owners/show"
  get "court_owners/new"
  get "court_owners/create"
  get "court_owners/edit"
  get "court_owners/update"
  get "court_owners/destroy"
  get "clients/index"
  get "clients/show"
  get "clients/new"
  get "clients/create"
  get "clients/edit"
  get "clients/update"
  get "clients/destroy"
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

  # Rotas para Clientes
  resources :clients


  # Rotas para Proprietários de Quadras
  resources :court_owners

end
