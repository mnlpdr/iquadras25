class NotificationWorker
  include Sidekiq::Worker

  # Configuração de retry: 5 tentativas com backoff exponencial
  sidekiq_options retry: 5, backtrace: true

  def perform(notification_type, reservation_id, reservation_data = nil)
    # Adicionar timeout para operações externas
    Timeout.timeout(30) do
      begin
        if reservation_data
          # Usa os dados passados se a reserva já foi deletada
          user = User.find(reservation_data["user_id"])
          create_log(notification_type, user, nil, reservation_data)
        else
          # Tenta buscar a reserva se ainda existir
          reservation = Reservation.find(reservation_id)
          case notification_type
          when 'reservation_created'
            send_email(NotificationService.send(:reservation_created_message, reservation))
            create_log(notification_type, reservation.user, reservation)
          when 'reservation_cancelled'
            send_email(NotificationService.send(:reservation_cancelled_message, reservation))
            create_log(notification_type, reservation.user, reservation)
          end
        end
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error "Reserva #{reservation_id} não encontrada para notificação #{notification_type}"
        Rails.logger.error e.message
      rescue Timeout::Error => e
        Rails.logger.error "Timeout ao processar notificação: #{e.message}"
        raise # Permite que o Sidekiq faça retry
      end
    end
  end

  private

  def create_log(notification_type, user, reservation = nil, details = {})
    NotificationLog.create!(
      notification_type: notification_type,
      user: user,
      reservation: reservation,
      status: 'sent',
      sent_at: Time.current,
      error_message: details.present? ? details.to_json : nil
    )
  end

  def send_email(message)
    EMAIL_CIRCUIT.run do
      Rails.logger.info "Enviando email:"
      Rails.logger.info "Para: #{message[:to]}"
      Rails.logger.info "Assunto: #{message[:subject]}"
      Rails.logger.info "Corpo: #{message[:body]}"
      
      # Aqui você colocaria o código real de envio de email
    end
  rescue Circuitbox::CircuitOpen => e
    Rails.logger.error "Circuit aberto para envio de emails: #{e.message}"
    # Salva para tentar novamente depois
    create_log("email_failed", User.find_by(email: message[:to]), nil, {
      reason: "circuit_open",
      to: message[:to],
      subject: message[:subject]
    })
  end
end