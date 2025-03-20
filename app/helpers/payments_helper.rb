module PaymentsHelper
  def payment_status_badge(status)
    case status.to_sym
    when :pending
      "bg-warning"
    when :completed
      "bg-success"
    when :failed
      "bg-danger"
    when :refunded
      "bg-info"
    when :cancelled
      "bg-secondary"
    else
      "bg-light"
    end
  end
end
