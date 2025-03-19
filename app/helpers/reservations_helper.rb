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
        slot_start = Time.zone.parse("#{date} #{slot[:start_time]}")
        slot_end = Time.zone.parse("#{date} #{slot[:end_time]}")
        
        (slot_start >= reservation.start_time && slot_start < reservation.end_time) ||
        (slot_end > reservation.start_time && slot_end <= reservation.end_time)
      end
    end
  end
end
