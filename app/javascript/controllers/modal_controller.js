import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal"];

  connect() {
    console.log("Modal controller connected");
  }

  open(event) {
    event.preventDefault();
    const deleteForm = document.getElementById("delete-form");
    deleteForm.action = event.currentTarget.dataset.modalUrlValue;

    document.body.classList.add("overflow-hidden");
    this.modalTarget.classList.remove("hidden");
  }

  close() {
    this.modalTarget.classList.add("hidden");
  }
}
