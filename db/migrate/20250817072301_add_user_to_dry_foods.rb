# db/migrate/20250817072301_add_user_to_dry_foods.rb
class AddUserToDryFoods < ActiveRecord::Migration[8.0]
  def up
    # Add the user_id column, allowing null values temporarily
    add_reference :dry_foods, :user, foreign_key: true, null: true

    # Nullify the dry_food_id in trackers before deleting the dry_foods
    # to avoid foreign key constraint errors.
    execute("UPDATE trackers SET dry_food_id = NULL")

    # Delete all existing DryFood records because we cannot determine their owner.
    execute("DELETE FROM dry_foods")

    # Now that the table is empty, change the column to be not null.
    change_column_null :dry_foods, :user_id, false
  end

  def down
    remove_reference :dry_foods, :user
  end
end