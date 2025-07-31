class CreateTrackers < ActiveRecord::Migration[8.0]
  def change
    create_table :trackers do |t|
      t.date :date
      t.time :feed_time
      t.time :come_back_to_eat_time
      t.string :brand
      t.string :description
      t.string :hungry
      t.decimal :amount, precision: 5, scale: 2
      t.decimal :left_amount, precision: 5, scale: 2
      t.string :result
      t.string :note
      t.integer :pet_id
      t.decimal :weight, precision: 4, scale: 2
      t.decimal :total_ate_amount, precision: 5, scale: 2
      t.integer :favorite_score, default: 0
      t.integer :frequency
      t.string :love
      t.date :transformed_date
      t.time :transformed_time

      t.timestamps
    end
  end
end
