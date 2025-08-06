class AddRemainingDaysToDryFoods < ActiveRecord::Migration[8.0]
  def change
    add_column :dry_foods, :days_remaining, :date
  end
end
