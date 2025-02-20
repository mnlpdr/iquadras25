class Court < ApplicationRecord

    has_many :reservations, dependent: :destroy
    has_many :court_sports
    has_many :sports, through: :court_sports

    def working_hours_range
        start_hour, end_hour = working_hours.split("-").map { |t| Time.zone.parse(t) }
        start_hour..end_hour
      end
end
