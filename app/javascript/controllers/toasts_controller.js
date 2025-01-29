import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toasts"
export default class extends Controller {
  connect() {
  }
  close(e){
    const toast = document.getElementById("toast");
    toast.innerHTML = "";
    toast.removeAttribute("src");
    toast.removeAttribute("complete")
  }
}
