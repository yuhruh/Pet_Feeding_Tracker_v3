class User < ApplicationRecord
  has_secure_password
  has_many :connected_services, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :pets, dependent: :destroy
  has_many :dry_foods, dependent: :destroy
  validates_associated :pets

  attr_accessor :email_address_confirmation

  validates :email_address, presence: true, 
                    uniqueness: { case_sensitive: false,
                    message: "has already been taken. Please choose another."}, 
                    length: { maximum: 105 },
                    format: { with: URI::MailTo::EMAIL_REGEXP, 
                    message: "must be a valid email format" }, allow_nil: true
  validates :email_address, confirmation: true, on: :create
  validates :password, presence: true, 
                    length: { maximum: 105 }
  validates :password_confirmation, presence: { message: "Upper and lower case should be the same."}
  validates :timezone, presence: true, on: :create

  normalizes :email_address, with: ->(e) { e.strip.downcase }


  def self.from_omniauth(auth)
    # Find the connected account first
    connected_account = ConnectedAccount.find_by(provider: auth.provider, uid: auth.uid)

    # If the connected account exists, return its user
    return connected_account.user if connected_account

    # If no connected account, find or create the user by email
    user = User.find_or_initialize_by(email_address: auth.info.email)

    # If the user is new, set their details
    if user.new_record?
      user.name = auth.info.name       # Assuming you have a 'name' attribute
      user.password = SecureRandom.hex # Set a random password for OAuth users
      # You might want to skip email confirmation for OAuth users if you have that feature
    end

    # Associate the new provider with the user
    user.connected_accounts.build(provider: auth.provider, uid: auth.uid)
    
    user.save
    user
  end
end
