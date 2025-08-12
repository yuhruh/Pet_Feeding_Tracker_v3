# app/controllers/registrations_controller.rb
class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  before_action :resume_session, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to new_pet_path, notice: "You've successfully signed up to Pet Feeding Tracker. Welcome #{@user.username.capitalize}!"
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
