import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    this.boundHideOnClickOutside = this.hideOnClickOutside.bind(this);
    document.addEventListener("click", this.boundHideOnClickOutside);
    console.log("header connected");
  }

  disconnect() {
    document.removeEventListener("click", this.boundHideOnClickOutside);
  }
  toggle() {
    this.menuTarget.classList.toggle("hidden");
  }

  hideOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
    }
  }
}
