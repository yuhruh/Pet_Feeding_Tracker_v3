class ChangeComeBackToEatTimeToStringInTrackers < ActiveRecord::Migration[8.0]
  def change
    change_column :trackers, :come_back_to_eat_time, :string
  end
end
