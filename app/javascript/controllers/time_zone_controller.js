import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['tz'];

  connect() {
    if (this.hasTzTarget) {
      this.tzTarget.value = Intl.DateTimeFormat().resolvedOptions().timeZone;
    }
  }

  setGoogleAuthUrl(event) {
    event.preventDefault();
    const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    const url = new URL(this.element.action);
    url.searchParams.append('timezone', timeZone);
    this.element.action = url.toString();
    this.element.submit();
  }


  setLineAuthUrl(event) {
    event.preventDefault();
    const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    const url = new URL(this.element.action);
    url.searchParams.append('timezone', timeZone);
    this.element.action = url.toString();
    this.element.submit();
  }
}
