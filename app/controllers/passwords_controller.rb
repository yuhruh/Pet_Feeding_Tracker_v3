class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  # responsible for sending the password reset email 
  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: t('.create_success')
  end

  def edit
  end

  def update 
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: t('.update_success')
    else
      error_messages = @user.errors.full_messages.join(", ")
      # redirect_to edit_password_path, alert: "Passwords did not match."
      redirect_to edit_password_path, alert: t('.update_failed', error_messages: error_messages)
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: t('.invalid_or_expired_link')
    end
end

