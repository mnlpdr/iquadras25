import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["court", "date", "slotSelect"]

  connect() {
    console.log("Controller conectado!")
    if (this.hasCourtTarget && this.hasDateTarget) {
      console.log("Tem court e date targets")
      this.updateAvailableSlots()
    }
  }

  // Chamado quando a quadra ou data mudam
  onChange() {
    console.log("onChange chamado")
    this.updateAvailableSlots()
  }

  updateAvailableSlots() {
    const courtId = this.courtTarget.value
    const date = this.dateTarget.value

    console.log("Atualizando slots:", { courtId, date })

    if (courtId && date) {
      fetch(`/reservations/available_slots?court_id=${courtId}&date=${date}`, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        },
        credentials: 'same-origin'
      })
        .then(response => {
          if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`)
          }
          return response.json()
        })
        .then(data => {
          console.log("Slots recebidos:", data)
          if (this.hasSlotSelectTarget) {
            this.slotSelectTarget.innerHTML = '<option value="">Selecione um horário</option>'
            
            data.forEach(slot => {
              const option = document.createElement('option')
              option.value = `${slot.start_time}-${slot.end_time}`
              option.textContent = slot.label
              this.slotSelectTarget.appendChild(option)
            })
          } else {
            console.log("Não encontrou o slotSelect target")
          }
        })
        .catch(error => {
          console.error("Erro ao buscar slots:", error)
        })
    } else {
      console.log("Falta courtId ou date")
    }
  }
} 