class User < ApplicationRecord
  before_save { self.password = password_confirmation }
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :pets, dependent: :destroy
  validates_associated :pets

  validates :email_address, presence: true, 
                    uniqueness: { case_sensitive: false,
                    message: "has already been taken. Please choose another."}, 
                    length: { maximum: 105 },
                    format: { with: URI::MailTo::EMAIL_REGEXP, 
                    message: "must be a valid email format" }, allow_nil: true
  validates :password, presence: true, 
                    length: { maximum: 105 }
  validates :password_confirmation, presence: { message: "Upper and lower case should be the same."}
  validates :timezone, presence: true, on: :create

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
