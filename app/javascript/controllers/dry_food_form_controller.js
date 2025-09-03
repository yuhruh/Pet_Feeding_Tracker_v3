import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "foodType", "dryFoodIdField", "wetFoodField", "brand", "description", "amountInput", "dryFoodSelect", "amountValidationMessage", "wetFoodDropdown" ]
  static values = {
    addDryFoodAlert: String,
    noFavoriteWetFoodAlert: String,
    selectFavoriteWetFood: String,
    enterValidAmount: String,
    amountExceedsStock: String,
    amountIsValid: String
  }

  connect() {
    this.toggleFoodFields()
    this.wetFoodsData = []
    this.amountInputTarget.addEventListener('input', () => this.validateAmount())
  }

  toggleFoodFields() {
    const selectedFoodType = this.foodTypeTarget.value
    const dryFoodCount = parseInt(this.element.dataset.dryFoodFormDryFoodsCount)

    this.dryFoodIdFieldTarget.style.display = 'none'
    this.wetFoodFieldTarget.style.display = 'none'
    this.dryFoodIdFieldTarget.querySelector('select').required = false
    this.clearValidation()

    if (selectedFoodType === "Dry") {
      if (dryFoodCount === 0) {
        alert(this.addDryFoodAlertValue)
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
    this.wetFoodsData = await response.json()
    const dropdown = this.wetFoodDropdownTarget

    if (this.wetFoodsData.length === 0) {
      dropdown.style.display = 'none';
      alert(this.noFavoriteWetFoodAlertValue);
      this.brandTarget.disabled = false;
      this.descriptionTarget.disabled = false;
      this.wetFoodFieldTarget.style.display = 'none'
    } else {
      dropdown.style.display = 'block';
      dropdown.innerHTML = `<option value="">${this.selectFavoriteWetFoodValue}</option>`;

      this.wetFoodsData.forEach((food, index) => {
        const option = document.createElement('option')
        option.value = index
        option.textContent = `${food.brand} - ${food.description} - "Favorite Score": ${food.favorite_score}`;
        dropdown.appendChild(option)
      })
    }
  }

  async fillFields() {
    const dryFoodId = this.dryFoodSelectTarget.value

    if (dryFoodId) {
      const response = await fetch(`/dry_foods/${dryFoodId}`)
      const data = await response.json()

      this.brandTarget.value = data.brand
      this.descriptionTarget.value = data.description
    } else {
      this.brandTarget.value = ""
      this.descriptionTarget.value = ""
    }
    this.validateAmount()
  }

  fillWetFoodFields() {
    const selectedIndex = this.wetFoodDropdownTarget.value
    if (selectedIndex) {
      const selectedFood = this.wetFoodsData[selectedIndex]
      this.brandTarget.value = selectedFood.brand
      this.descriptionTarget.value = selectedFood.description
      this.amountInputTarget.value = selectedFood.amount
    } else {
      this.brandTarget.value = ""
      this.descriptionTarget.value = ""
      this.amountInputTarget.value = ""
    }
  }

  validateAmount() {
    if (this.foodTypeTarget.value !== 'Dry' || !this.hasDryFoodSelectTarget) {
      this.clearValidation()
      return
    }

    const selectedOption = this.dryFoodSelectTarget.selectedOptions[0]
    if (!selectedOption || !selectedOption.dataset.leftAmount) {
      this.clearValidation()
      return
    }

    const leftAmount = parseFloat(selectedOption.dataset.leftAmount)
    const currentAmount = parseFloat(this.amountInputTarget.value)

    this.amountInputTarget.max = leftAmount

    if (this.amountInputTarget.value === '') {
      this.clearValidation();
      return;
    }

    if (isNaN(currentAmount) || currentAmount <= 0) {
      this.amountValidationMessageTarget.textContent = this.enterValidAmountValue
      this.amountValidationMessageTarget.style.color = "red"
    } else if (currentAmount > leftAmount) {
      this.amountValidationMessageTarget.textContent = this.amountExceedsStockValue.replace('%{leftAmount}', leftAmount)
      this.amountValidationMessageTarget.style.color = "red"
    } else {
      this.amountValidationMessageTarget.textContent = this.amountIsValidValue
      this.amountValidationMessageTarget.style.color = "green"
    }
  }

  clearValidation() {
    if (this.hasAmountValidationMessageTarget) {
      this.amountValidationMessageTarget.textContent = ""
    }
    if (this.hasAmountInputTarget) {
      this.amountInputTarget.removeAttribute('max')
    }
  }
}
