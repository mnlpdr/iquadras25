// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import "controllers"
import "bootstrap"

// Desabilitar o cache do Turbo para formulários
document.addEventListener("turbo:load", () => {
  if (typeof Turbo !== 'undefined') {
    Turbo.setFormMode("off")
  }
})
