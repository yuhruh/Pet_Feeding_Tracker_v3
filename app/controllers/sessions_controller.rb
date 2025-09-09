class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: t(".try_again_later") }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      flash[:notice] = t(".welcome")
      redirect_to after_authentication_url
    else
      local_user = User.find_by(email_address: params[:email_address])
      if local_user.connected_services.any?
        flash[:alert] = t(".existing_connection", service: connected_services_string(local_user))
      else
        flash[:alert] = t(".invalid_credentials")
      end
      redirect_to new_session_path
    end
  end

  def destroy
    terminate_session
    flash[:alert] = t(".signed_out")
    redirect_to new_session_path
  end

  private
  def connected_services_string(user)
    user.connected_services.map(&:provider).to_sentence(last_word_connector: " or")
  end
end
