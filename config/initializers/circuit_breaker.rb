require 'circuitbox'

# Configuração compatível com circuitbox 2.0.0
EMAIL_CIRCUIT = Circuitbox.circuit(:email_service, {
  # Tempo em segundos para considerar falhas (janela de 60 segundos)
  time_window: 60,
  # Porcentagem de falhas para abrir o circuito (50%)
  error_threshold: 50,
  # Tempo em segundos para o circuito permanecer aberto antes de tentar novamente
  sleep_window: 300,
  # Exceções que devem ser consideradas falhas
  exceptions: [Net::SMTPError, Timeout::Error, StandardError]
}) 