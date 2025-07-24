class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    # @token = @user.signed_id(purpose: "password_reset", expires_in: 15.minutes)
    mail subject: "Reset your password", to: @user.email_address
  end
end
