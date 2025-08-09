import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "foodType", "dryFoodIdField", "brand", "description" ]

  connect() {
    this.toggleDryFoodField()
  }

  toggleDryFoodField() {
    const selectedFoodType = this.foodTypeTarget.value
    const dryFoodCount = parseInt(this.element.dataset.dryFoodFormDryFoodsCount)

    if (selectedFoodType === "Dry") {
      if (dryFoodCount === 0) {
        alert("You haven't added any dry food yet. Would you like to add one now?")
        window.location.href = "/dry_foods/new"
      } else {
        this.dryFoodIdFieldTarget.style.display = 'block'
        this.dryFoodIdFieldTarget.querySelector('select').required = true
      }
    } else {
      this.dryFoodIdFieldTarget.style.display = 'none'
      this.dryFoodIdFieldTarget.querySelector('select').required = false
    }
  }

  async fillFields() {
    const dryFoodId = this.dryFoodIdFieldTarget.querySelector('select').value

    if (dryFoodId) {
      const response = await fetch(`/dry_foods/${dryFoodId}`)
      const data = await response.json()


      this.brandTarget.value = data.brand
      this.descriptionTarget.value = data.description
    } else {
      this.brandTarget.value = ""
      this.descriptionTarget.value = ""
    }
  }
}