module ReservationsHelper
  def available_time_slots(date, court)
    all_slots = (6..22).map do |hour|
      start_time = Time.zone.local(date.year, date.month, date.day, hour, 0)
      end_time = Time.zone.local(date.year, date.month, date.day, hour + 1, 0)
      
      {
        start_time: start_time.strftime("%H:%M"),
        end_time: end_time.strftime("%H:%M"),
        label: "#{format('%02d', hour)}:00 - #{format('%02d', hour + 1)}:00"
      }
    end

    existing_reservations = Reservation.where(
      court_id: court.id,
      date: date
    )

    # Remove slots que já têm reservas
    all_slots.reject do |slot|
      existing_reservations.any? do |reservation|
        (slot[:start_time] >= reservation.start_time.strftime("%H:%M") &&
         slot[:start_time] < reservation.end_time.strftime("%H:%M")) ||
        (slot[:end_time] > reservation.start_time.strftime("%H:%M") &&
         slot[:end_time] <= reservation.end_time.strftime("%H:%M"))
      end
    end
  end
end
