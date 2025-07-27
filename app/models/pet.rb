class Pet < ApplicationRecord
  belongs_to :user
  # has_many :trackers, dependent: :destroy
  validates :petname, presence: true, 
                      length: { minimum: 2, maximum: 25 }
end
