import { Application, Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"
  window.Stimulus = Application.start()

  Stimulus.register("time-zone", class extends Controller {
    static targets = [ "tz" ];
    
    initialize() {
      this.tzTarget.value = Intl.DateTimeFormat().resolvedOptions().timeZone;
    }
  })