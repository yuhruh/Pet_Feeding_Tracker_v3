class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates :email_address, presence: true, 
                    uniqueness: true, 
                    length: { maximum: 105 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
   validates :password, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
