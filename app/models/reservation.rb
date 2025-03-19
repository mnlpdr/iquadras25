class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :court
  has_one :payment, dependent: :restrict_with_exception

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :valid_reservation_times
  validate :end_time_after_start_time
  validate :no_overlapping_reservations

  enum :status, { pending_payment: 0, confirmed: 1, cancelled: 2, completed: 3 }

  # Atributo virtual para o formulário
  attr_accessor :time_slot

  # Método para obter a data da reserva a partir do start_time
  def date
    start_time&.to_date
  end

  # Método para calcular o preço total da reserva
  def total_price
    return 0 unless start_time && end_time && court && court.price_per_hour
    
    # Calcula a duração em horas
    duration_in_hours = (end_time - start_time) / 1.hour
    
    # Multiplica pelo preço por hora da quadra
    (duration_in_hours * court.price_per_hour).round(2)
  end

  private

  def valid_reservation_times
    if start_time.present? && (start_time.hour < 6 || start_time.hour > 23)
      errors.add(:start_time, "deve estar entre 06:00 e 23:00")
    end

    if end_time.present? && (end_time.hour < 6 || end_time.hour > 23)
      errors.add(:end_time, "deve estar entre 06:00 e 23:00")
    end
  end

  def end_time_after_start_time
    if start_time.present? && end_time.present? && end_time <= start_time
      errors.add(:end_time, :after_start_time)
    end
  end
  

  def no_overlapping_reservations
    return unless court_id && start_time && end_time
    
    # Usar a data do start_time
    reservation_date = start_time.to_date
    
    overlapping_reservations = Reservation.where(court_id: court_id)
      .where.not(id: id) # Ignora a própria reserva ao editar
      .where("DATE(start_time) = ? AND start_time < ? AND end_time > ?", 
             reservation_date, end_time, start_time)

    if overlapping_reservations.exists?
      errors.add(:base, "Já existe uma reserva nesse horário para esta quadra")
    end
  end
end
