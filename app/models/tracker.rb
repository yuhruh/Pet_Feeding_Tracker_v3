class Tracker < ApplicationRecord
  belongs_to :pet
  belongs_to :dry_food, optional: true
  before_save { self.brand = brand.downcase }
  before_save { self.description = description.downcase }
  validates :food_type, presence: true
  validates :brand, presence: true, length: {minimum: 1, maximum: 50}
  validates :description, presence: true, length: {minimum: 2, maximum: 100}
  validates :amount, numericality: true, comparison: { greater_than: 0 }
  validate :amount_less_than_dry_food_left_amount, if: :dry_food?

  # add callback to synchronization automatically
  after_commit :update_dry_food_used_amount, on: [:create, :update, :destroy]

  private

  def dry_food?
    food_type == 'Dry' && dry_food.present?
  end

  def amount_less_than_dry_food_left_amount
    if amount.present? && dry_food.left_amount < amount
      errors.add(:amount, "can't be greater than the remaining amount of dry food (#{dry_food.left_amount})")
    end
  end

  def update_dry_food_used_amount
    if dry_food
      used_amount = dry_food.trackers.sum(:amount)
      left_amount = dry_food.amount - used_amount
      trackers_count = dry_food.trackers.count.to_i

      if trackers_count > 0
        average_used_amount = used_amount / trackers_count.to_f
        days_remaining = (left_amount / average_used_amount).to_i rescue nil
        expected_running_out = days_remaining ? dry_food.created_at + days_remaining.days : nil


        dry_food.update_columns(
          used_amount: used_amount,
          left_amount: left_amount,
          average_used_amount: average_used_amount.round(2),
          days_remaining: expected_running_out
          )
      else
        dry_food.update_columns(
          used_amount: used_amount,
          left_amount: left_amount,
          average_used_amount: 0,
          days_remaining: nil
        )
      end
    end
  
  end

end
