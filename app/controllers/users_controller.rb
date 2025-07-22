class UsersController < ApplicationController
  before_action :require_same_user, only: %i[ edit update destroy ]

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.expect(user: [ :username, :email ])
    end

    def require_same_user
      if current_user != @user && !current_user.admin?
        flash[:alert] = "You can only edit or delete your own account...."
        redirect_to @user
      end
    end
end
