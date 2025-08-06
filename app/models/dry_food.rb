class DryFood < ApplicationRecord
  has_many :trackers, dependent: :nullify
end
