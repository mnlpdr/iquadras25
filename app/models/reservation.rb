class Reservation < ApplicationRecord
  belongs_to :court
  belongs_to :user

  validates :start_time, :end_time, presence: true
  validate :check_availability

  private

  def check_availability
    overlapping_reservations = Reservation.where(court_id: court_id)
                                          .where("start_time < ? AND end_time > ?", end_time, start_time)
    if overlapping_reservations.exists?
      errors.add(:base, "Este horário já está reservado para esta quadra.")
    end
  end
end
