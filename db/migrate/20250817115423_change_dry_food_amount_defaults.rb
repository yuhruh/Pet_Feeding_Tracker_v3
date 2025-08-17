class ChangeDryFoodAmountDefaults < ActiveRecord::Migration[8.0]
  def change
    change_column_default :dry_foods, :amount, from: nil, to: 0.0
    change_column_default :dry_foods, :used_amount, from: nil, to: 0.0
    change_column_default :dry_foods, :left_amount, from: nil, to: 0.0

    # To update existing records that have nil values
    DryFood.where(amount: nil).update_all(amount: 0.0)
    DryFood.where(used_amount: nil).update_all(used_amount: 0.0)
    DryFood.where(left_amount: nil).update_all(left_amount: 0.0)
  end
end