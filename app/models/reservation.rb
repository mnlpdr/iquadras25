class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :court

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :valid_reservation_times
  validate :end_time_after_start_time
  validate :no_overlapping_reservations

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
    overlapping_reservations = Reservation.where(court_id: court_id)
      .where.not(id: id) # Ignora a própria reserva ao editar
      .where("date = ? AND start_time < ? AND end_time > ?", date, end_time, start_time)

    if overlapping_reservations.exists?
      errors.add(:base, "Já existe uma reserva nesse horário para esta quadra")
    end
  end
end
