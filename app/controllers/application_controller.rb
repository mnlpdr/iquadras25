class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Adicionando a verificação de login para as ações que requerem o usuário autenticado
  before_action :authenticate_user!, except: [:home, :index]  # Excluindo páginas públicas (home e index, por exemplo)
end
