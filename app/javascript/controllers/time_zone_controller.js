import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['tz'];

  connect() {
    this.tzTarget.value = Intl.DateTimeFormat().resolvedOptions().timeZone;
  }
}