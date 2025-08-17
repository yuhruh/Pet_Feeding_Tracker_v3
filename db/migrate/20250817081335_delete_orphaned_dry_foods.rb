# db/migrate/20250817081335_delete_orphaned_dry_foods.rb
class DeleteOrphanedDryFoods < ActiveRecord::Migration[8.0]
  def up
    DryFood.where(user_id: nil).delete_all
  end

  def down
    # This migration is not reversible.
  end
end