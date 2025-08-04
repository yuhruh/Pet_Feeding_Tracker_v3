class AddDryFoodToTrackers < ActiveRecord::Migration[8.0]
  def change
    add_reference :trackers, :dry_food, foreign_key: true
  end
end
