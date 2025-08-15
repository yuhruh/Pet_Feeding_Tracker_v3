class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      flash[:notice] = "Welcome to Cat Feeding Tracker."
      redirect_to after_authentication_url
    else
      local_user = User.find_by(email_address: params[:email_address])
      if local_user.connected_service.any?
        flash[:alert] = "You've previously signed in using your #{connected_services_string(local_user)} account. Please use that to sign in."
      else
        flash[:alert] = "Try another email address or password."
      end
      redirect_to new_session_path
    end
  end

  def destroy
    terminate_session
    flash[:alert] = "You have been signed out."
    redirect_to new_session_path
  end

  private
  def connected_services_string(user)
    user.connected_services.map(&:provider).to_sentence(last_word_connector: " or")
  end
end
