class DryFood < ApplicationRecord
  belongs_to :user
  has_many :trackers, dependent: :nullify

  before_create :set_left_amount

  private

  def set_left_amount
    self.left_amount = amount
  end
end
