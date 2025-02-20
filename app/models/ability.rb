class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Usuário não autenticado (convidado)

    if user.admin?
      can :manage, :all  # Administradores podem gerenciar tudo
      can :create, User
      can :new, User

    elsif user.court_owner?
      can :manage, Court, owner_id: user.id # Pode gerenciar apenas suas próprias quadras
      can :destroy, Court, owner_id: user.id # 🔹 Agora pode excluir suas próprias quadras
      can :read, Reservation, court: { owner_id: user.id } # Pode ver reservas de suas quadras
      can :destroy, Reservation, court: { owner_id: user.id } # Pode cancelar reservas feitas em suas quadras

      # Dono de quadra só pode criar reservas EM SUAS PRÓPRIAS QUADRAS
      can :create, Reservation do |reservation|
        reservation.court.present? && reservation.court.owner_id == user.id
      end

    elsif user.client?
      can :create, Reservation  # Pode criar reservas em qualquer quadra
      can :read, Reservation, user_id: user.id # Pode ver suas próprias reservas
      can :destroy, Reservation, user_id: user.id # Pode cancelar suas reservas
      can :read, Court # Pode ver todas as quadras disponíveis
    end
  end
end
