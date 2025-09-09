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
      flash[:notice] = t("flash.notice.connected", provider: @service.provider.to_s.humanize)
      redirect_to new_pet_path
    else
      start_new_session_for @user
      flash[:notice] = t("flash.notice.signed_in")
      redirect_to new_pet_path
    end
  end

  def failure
    if params[:message] == "access_denied"
      flash[:alert] = t("flash.alert.cancelled_signin")
    else
      flash[:alert] = t("flash.alert.issue_with_signin")
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
      flash[:notice] = t("flash.notice.existing_account", service_methods: service_methods)
      redirect_to new_session_path
    else
      if user_info.dig(:info, :email).blank? && user_info.provider == "line"
        session["omniauth.auth"] = user_info.to_hash
        flash[:notice] = t("flash.notice.enter_email_for_line")
        redirect_to new_registrations_path and return
      elsif user_info.dig(:info, :email).blank?
        flash[:alert] = t("flash.alert.enter_email_to_register")
        redirect_to new_registrations_path and return
      else
        @user = create_user
        UserMailer.with(user: @user).welcome.deliver_later
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