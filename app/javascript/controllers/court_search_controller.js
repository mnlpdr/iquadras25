import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "sportSelect", "card"]

  filter() {
    const query = this.inputTarget.value.toLowerCase()
    const selectedSport = this.sportSelectTarget.value

    this.cardTargets.forEach(card => {
      const name = card.dataset.name.toLowerCase()
      const location = card.dataset.location.toLowerCase()
      const sportIds = card.dataset.sportIds.split(',')
      
      const matchesSearch = name.includes(query) || location.includes(query)
      const matchesSport = !selectedSport || sportIds.includes(selectedSport)

      card.style.display = matchesSearch && matchesSport ? '' : 'none'
    })
  }
} 