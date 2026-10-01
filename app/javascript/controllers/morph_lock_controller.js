import { Controller } from "@hotwired/stimulus";

// Prevents Turbo page-morph from clearing the parent <turbo-frame> while
// this controller is connected.  Attach it to any element inside a frame
// whose content should survive broadcast-triggered refreshes (e.g. an
// open transaction-edit drawer).
export default class extends Controller {
  connect() {
    this.frame = this.element.closest("turbo-frame");
    if (!this.frame) return;

    this.boundPrevent = this.#prevent.bind(this);
    document.addEventListener("turbo:before-morph-element", this.boundPrevent);
  }

  disconnect() {
    if (this.boundPrevent) {
      document.removeEventListener("turbo:before-morph-element", this.boundPrevent);
    }
  }

  #prevent(event) {
    if (event.target === this.frame) {
      event.preventDefault();
    }
  }
}
