class NotificationRetryWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: 10
  
  def perform(notification_type, record_id)
    case notification_type
    when 'reservation_created'
      reservation = Reservation.find_by(id: record_id)
      NotificationService.notify_reservation_created(reservation) if reservation
    when 'reservation_cancelled'
      # Lógica para retry de cancelamento
    end
  end
end 