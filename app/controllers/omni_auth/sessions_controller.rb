class OmniAuth::SessionsController < ApplicationController
  allow_unauthenticated_access only: [:create, :failure]
  before_action :set_service, only: [:create]
  before_action :set_user, only: [:create]

  # def omniauth_request
  #   session[:user_timezone] = params[:timezone]
  #   redirect_to "/auth/#{params[:provider]}"
  # end

  def create
    if !@service.present?
      @service = @user.connected_services.create!(provider: user_info.provider, uid: user_info.uid)
    end

    if Current.user.present?
      flash[:notice] = "#{@service.provider.to_s.humanize} connected"
      redirect_to new_pet_path
    else
      start_new_session_for @user
      flash[:notice] = "You have been signed in. Welcome to Cat Feeding Tracker App."
      redirect_to new_pet_path
    end
  end

  def failure
    if params[:message] == "access_denied"
      flash[:alert] = "You cancelled the sign in process. Please try again."
    else
      flash[:alert] = "There was an issue with the sign in process. Please try again."
    end

    redirect_to new_session_path
  end

  private

  

  def user_info
    @user_info ||= request.env['omniauth.auth']
  end

  def set_service
    @service = ConnectedService.find_by(provider: user_info.provider, uid: user_info.uid)
  end

  def set_user
    user = resume_session.try(:user)
    if user.present?
      @user = user
    elsif @service.present?
      @user = @service.user
    elsif User.find_by(email_address: user_info.dig(:info, :email)).present?
      service_methods = ConnectedService.where(user_id: User.find_by(email_address: user_info.dig(:info, :email))).pluck(:provider).map(&:to_s).join(", ")
      flash[:notice] = "There's already an account with this email address. Please sign in with it using your #{service_methods} account to associate it with this service."
      redirect_to new_session_path
    else
      if user_info.dig(:info, :email).blank? && user_info.provider == "line"
        session["omniauth.auth"] = user_info.to_hash
        flash[:notice] = "Please enter an email address to complete your LINE registration."
        redirect_to new_registrations_path and return
      elsif user_info.dig(:info, :email).blank?
        flash[:alert] = "Please enter an email address to complete your registration."
        redirect_to new_registrations_path and return
      else
        @user = create_user
      end
    end
  end

  def create_user
    email = user_info.dig(:info, :email)
    username = user_info.dig(:info, :name) || user_info.dig(:info, :email).split('@').first
    random_password = SecureRandom.hex(10)
    user_timezone = request.env.dig('omniauth.params', 'timezone')

    User.create!(
      email_address: email,
      username: username,
      password: random_password,
      password_confirmation: random_password,
      timezone: user_timezone)
  end

end