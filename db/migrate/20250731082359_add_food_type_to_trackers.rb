class AddFoodTypeToTrackers < ActiveRecord::Migration[8.0]
  def change
    add_column :trackers, :food_type, :string
  end
end
