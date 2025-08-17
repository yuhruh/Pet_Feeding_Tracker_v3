# db/migrate/20250817072301_add_user_to_dry_foods.rb
class AddUserToDryFoods < ActiveRecord::Migration[8.0]
  def change
    add_reference :dry_foods, :user, null: false, foreign_key: true
  end
end