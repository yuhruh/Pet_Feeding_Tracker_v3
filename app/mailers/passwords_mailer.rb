class PasswordsMailer < ApplicationMailer
  default from: 'notifications@example.com'
  
  def reset(user)
    @user = user
    mail subject: "Reset your password", to: @user.email_address
  end
end
