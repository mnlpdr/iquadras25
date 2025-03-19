import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["indicator"]
  
  connect() {
    this.checkHealth()
    this.interval = setInterval(() => this.checkHealth(), 30000) // Verifica a cada 30 segundos
  }
  
  disconnect() {
    clearInterval(this.interval)
  }
  
  async checkHealth() {
    try {
      const response = await fetch('/health', {
        headers: { 'Accept': 'application/json' }
      })
      
      if (response.ok) {
        this.indicatorTarget.classList.remove('bg-danger', 'bg-warning')
        this.indicatorTarget.classList.add('bg-success')
        this.indicatorTarget.setAttribute('title', 'Sistema funcionando normalmente')
      } else {
        const data = await response.json()
        this.showDegradedStatus(data)
      }
    } catch (error) {
      this.showOfflineStatus()
    }
  }
  
  showDegradedStatus(data) {
    this.indicatorTarget.classList.remove('bg-success', 'bg-danger')
    this.indicatorTarget.classList.add('bg-warning')
    
    let message = "Alguns serviços estão indisponíveis: "
    if (!data.services.database) message += "Banco de dados, "
    if (!data.services.redis_primary) message += "Redis principal, "
    if (!data.services.redis_replica) message += "Redis réplica, "
    if (!data.services.sidekiq) message += "Processamento de notificações, "
    
    this.indicatorTarget.setAttribute('title', message.slice(0, -2))
  }
  
  showOfflineStatus() {
    this.indicatorTarget.classList.remove('bg-success', 'bg-warning')
    this.indicatorTarget.classList.add('bg-danger')
    this.indicatorTarget.setAttribute('title', 'Servidor indisponível')
  }
} 