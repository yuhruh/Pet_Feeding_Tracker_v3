class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  default from: 'notifications@example.com'

  def welcome
    @user = params[:user]
    mail(to: @user.email_address, subject: 'Welcome to Cat Trackers App!')
  end
end
