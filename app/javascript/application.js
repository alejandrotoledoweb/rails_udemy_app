// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "flowbite";
// import "flowbite/dist/flowbite.turbo.js";

import "trix";
import "@rails/actiontext";
// import "chartkick";
// import "Chart.bundle";

// import "chartkick/chart.js"; // by enabling this the rich text editor crashes

document.addEventListener("turbo:frame-missing", (event) => {
  const {
    detail: { response, visit },
  } = event;
  event.preventDefault();
  visit(response.url);
});
