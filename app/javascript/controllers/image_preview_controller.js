import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  connect() {
    if (this.hasPreviewTarget && this.hasInputTarget) {
      this.inputTarget.addEventListener("change", this.previewImage.bind(this))
    }
  }

  previewImage() {
    const input = this.inputTarget
    const preview = this.previewTarget
    
    if (input.files && input.files[0]) {
      const reader = new FileReader()
      
      reader.onload = function(e) {
        preview.src = e.target.result
        preview.style.display = 'block'
      }
      
      reader.readAsDataURL(input.files[0])
    }
  }
} 