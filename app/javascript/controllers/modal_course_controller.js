import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modalCourse"];

  connect() {
    console.log("Modal course connected");
  }

  open(event) {
    event.preventDefault();
    const deleteForm = document.getElementById("delete-form");
    deleteForm.action = event.currentTarget.dataset.modalUrlValue;
    this.modalCourseTarget.classList.remove("hidden");
  }

  close() {
    this.modalCourseTarget.classList.add("hidden");
  }
}
