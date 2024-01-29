import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  connect() {
    console.log("connected search");
  }

  static targets = ["input", "courses"];

  search() {
    const searchTerm = this.inputTarget.value.toLowerCase();

    this.coursesTargets.forEach((course) => {
      const title = course.getAttribute("data-title");
      course.style.display = title.includes(searchTerm) ? "" : "none";
    });
  }
}
