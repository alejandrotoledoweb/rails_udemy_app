import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu", "teacherMenu", "studentMenu"];

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

    if (this.teacherMenuTarget) {
      this.teacherMenuTarget.classList.add("hidden");
    }
    if (this.studentMenuTarget) {
      this.studentMenuTarget.classList.add("hidden");
    }
  }
  toggleTeacher() {
    this.teacherMenuTarget.classList.toggle("hidden");

    if (this.studentMenuTarget || this.menuTarget) {
      this.studentMenuTarget.classList.add("hidden");
      this.menuTarget.classList.add("hidden");
    }
  }
  toggleStudent() {
    this.studentMenuTarget.classList.toggle("hidden");

    if (this.teacherMenuTarget || this.menuTarget) {
      this.teacherMenuTarget.classList.add("hidden");
      this.menuTarget.classList.add("hidden");
    }
  }

  hideOnClickOutside(event) {
    console.log("clicked outside");
    if (!this.element.contains(event.target)) {
      if (this.studentMenuTarget) {
        this.studentMenuTarget.classList.add("hidden");
      }
      if (this.teacherMenuTarget) {
        this.teacherMenuTarget.classList.add("hidden");
      }
      if (this.menuTarget) {
        this.menuTarget.classList.add("hidden");
      }
    }
  }
}
