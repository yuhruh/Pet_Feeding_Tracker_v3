# app/controllers/registrations_controller.rb
class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  before_action :resume_session, only: %i[new create]

  def new
    @user = User.new

    # if session["omniauth.auth"].present?
    #   auth_info = session["omniauth.auth"]["info"]
    #   @user.username = auth_info["name"] || session["omniauth.auth"]["uid"]
    # end

    if session["omniauth.auth"].present?
    auth_data = session["omniauth.auth"]
    auth_info = auth_data["info"] || {}
    
    # Handle LINE-specific username structure
      if auth_data["provider"] == "line"
        # LINE typically provides displayName or name
        @user.username = auth_info["name"] || 
                        auth_info["displayName"] || 
                        "line_user_#{auth_data['uid']}"
        
        # Email might not be available for LINE without permission
        @user.email_address = auth_info["email"] if auth_info["email"].present?
      else
        # Handle other providers
        @user.username = auth_info["name"] || auth_info["email"]&.split('@')&.first
        @user.email_address = auth_info["email"]
      end
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if session["omniauth.auth"].present?
        auth_data = session["omniauth.auth"]
        @user.connected_services.create!(
          provider: auth_data["provider"],
          uid: auth_data["uid"]
        )
        session.delete("omniauth.auth")
      end

      start_new_session_for @user
      UserMailer.with(user: @user).welcome.deliver_later
      redirect_to new_pet_path, notice: t(".successfully_signed_up", username: @user.username.capitalize)
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: [:username, :email_address, :email_address_confirmation, :password, :password_confirmation, :timezone])
  end
end
