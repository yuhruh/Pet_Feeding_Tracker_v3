import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "foodType", "dryFoodIdField", "wetFoodField", "brand", "description" ]

  connect() {
    this.toggleFoodFields()
  }

  toggleFoodFields() {
    const selectedFoodType = this.foodTypeTarget.value
    const dryFoodCount = parseInt(this.element.dataset.dryFoodFormDryFoodsCount)

    this.dryFoodIdFieldTarget.style.display = 'none'
    this.wetFoodFieldTarget.style.display = 'none'
    this.dryFoodIdFieldTarget.querySelector('select').required = false

    if (selectedFoodType === "Dry") {
      if (dryFoodCount === 0) {
        alert("You haven't added any dry food yet. Would you like to add one now?")
        window.location.href = "/dry_foods/new"
      } else {
        this.dryFoodIdFieldTarget.style.display = 'block'
        this.dryFoodIdFieldTarget.querySelector('select').required = true
      }
    } else if (selectedFoodType === "Wet") {
      this.wetFoodFieldTarget.style.display = 'block'
      this.fetchWetFoods()
    } else {
      this.brandTarget.value = ""
      this.descriptionTarget.value = ""
    }
  }

  async fetchWetFoods() {
    const response = await fetch(`/pets/${this.element.dataset.petId}/trackers/random_wet_foods`)
    const data = await response.json()
    const dropdown = this.wetFoodFieldTarget.querySelector('select')
    
    // Clear existing options
    dropdown.innerHTML = '<option value="">Select a favorite wet food</option>'
    
    // Add new options from the fetched data
    data.forEach(food => {
      const option = document.createElement('option')
      option.value = `${food.brand} - ${food.description} - ${food.favorite_score}`
      option.textContent = `${food.brand} - ${food.description} - ${food.favorite_score}`
      dropdown.appendChild(option)
    })
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

  fillWetFoodFields() {
    const selectedValue = this.wetFoodFieldTarget.querySelector('select').value
    if (selectedValue) {
      const [brand, description] = selectedValue.split(' - ')
      this.brandTarget.value = brand.trim()
      this.descriptionTarget.value = description.trim()
    } else {
      this.brandTarget.value = ""
      this.descriptionTarget.value = ""
    }
  }
}