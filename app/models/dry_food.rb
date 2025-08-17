class DryFood < ApplicationRecord
  belongs_to :user
  has_many :trackers, dependent: :nullify
end
