class NotificationService
  class << self
    def notify_reservation_created(reservation)
      Rails.logger.info "Preparando notificação de nova reserva: #{reservation.id}"
      NotificationWorker.perform_async('reservation_created', reservation.id)
    end

    def notify_reservation_cancelled(reservation)
      Rails.logger.info "Preparando notificação de cancelamento: #{reservation.id}"
      NotificationWorker.perform_async('reservation_cancelled', reservation.id)
    end

    def notify_court_created(court)
      Rails.logger.info "Registrando criação de quadra: #{court.id}"
      create_system_log('court_created', court.owner, nil, {
        court_id: court.id,
        court_name: court.name,
        action: 'created'
      })
    end

    def notify_court_updated(court)
      Rails.logger.info "Registrando atualização de quadra: #{court.id}"
      create_system_log('court_updated', court.owner, nil, {
        court_id: court.id,
        court_name: court.name,
        action: 'updated'
      })
    end

    def notify_court_deleted(court)
      Rails.logger.info "Registrando exclusão de quadra: #{court.id}"
      create_system_log('court_deleted', court.owner, nil, {
        court_id: court.id,
        court_name: court.name,
        action: 'deleted'
      })
    end

    # Novos métodos para notificações de pagamento
    def notify_payment_created(payment)
      Rails.logger.info "Registrando criação de pagamento: #{payment.id}"
      create_system_log('payment_created', payment.user, payment.reservation, {
        payment_id: payment.id,
        payment_amount: payment.amount,
        payment_status: payment.status,
        payment_intent_id: payment.stripe_payment_intent_id
      })
    end

    def notify_payment_completed(payment)
      Rails.logger.info "Registrando confirmação de pagamento: #{payment.id}"
      create_system_log('payment_completed', payment.user, payment.reservation, {
        payment_id: payment.id,
        payment_amount: payment.amount,
        payment_status: payment.status,
        payment_intent_id: payment.stripe_payment_intent_id,
        payment_id: payment.stripe_payment_id
      })
    end

    def notify_payment_failed(payment, error_message = nil)
      Rails.logger.info "Registrando falha de pagamento: #{payment.id}"
      create_system_log('payment_failed', payment.user, payment.reservation, {
        payment_id: payment.id,
        payment_amount: payment.amount,
        payment_status: payment.status,
        payment_intent_id: payment.stripe_payment_intent_id,
        error: error_message
      })
    end

    def notify_payment_refunded(payment)
      Rails.logger.info "Registrando reembolso de pagamento: #{payment.id}"
      create_system_log('payment_refunded', payment.user, payment.reservation, {
        payment_id: payment.id,
        payment_amount: payment.amount,
        payment_status: payment.status,
        refund_date: Time.current
      })
      
      # Se você tiver um sistema de e-mail configurado, pode descomentar esta linha
      # UserMailer.refund_confirmation(payment).deliver_later
    end

    private

    def create_system_log(notification_type, user, reservation = nil, details = {})
      NotificationLog.create!(
        notification_type: notification_type,
        user: user,
        reservation: reservation,
        status: 'sent',
        sent_at: Time.current,
        error_message: details.to_json
      )
    end

    def reservation_created_message(reservation)
      {
        to: reservation.user.email,
        subject: "Reserva Confirmada - iQuadras",
        body: <<~BODY
          Olá #{reservation.user.name},

          Sua reserva foi confirmada com sucesso!

          Detalhes da reserva:
          Quadra: #{reservation.court.name}
          Data: #{I18n.l(reservation.date, format: :long)}
          Horário: #{I18n.l(reservation.start_time, format: :time)} - #{I18n.l(reservation.end_time, format: :time)}
          
          Agradecemos a preferência!
          
          Atenciosamente,
          Equipe iQuadras
        BODY
      }
    end

    def reservation_cancelled_message(reservation)
      {
        to: reservation.user.email,
        subject: "Reserva Cancelada - iQuadras",
        body: <<~BODY
          Olá #{reservation.user.name},

          Sua reserva foi cancelada conforme solicitado.

          Detalhes da reserva cancelada:
          Quadra: #{reservation.court.name}
          Data: #{I18n.l(reservation.date, format: :long)}
          Horário: #{I18n.l(reservation.start_time, format: :time)} - #{I18n.l(reservation.end_time, format: :time)}
          
          Esperamos você em uma próxima reserva!
          
          Atenciosamente,
          Equipe iQuadras
        BODY
      }
    end
  end
end 