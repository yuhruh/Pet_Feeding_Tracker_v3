class DryFoodsController < ApplicationController
  before_action :set_dry_food, only: %i[ show destroy ]

  def index
    @dry_foods = Current.user.dry_foods
  end

  def show
    render json: @dry_food, only: [:brand, :description]
  end

  def new
    @dry_food = Current.user.dry_foods.build
  end


  def create
    @dry_food = Current.user.dry_foods.build(dryfood_params)

    respond_to do |format|
      if @dry_food.save
        format.html { redirect_to dry_foods_path, notice: t('.create_success') }
        format.json { render :show, status: :created, location: dry_foods_path }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dry_food.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @dry_food.destroy!

    respond_to do |format|
      format.html { redirect_to dry_foods_path, status: :see_other, notice: t('.destroy_success', brand: @dry_food.brand, description: @dry_food.description) }
      format.json { head :no_content }
    end
  end


  private

    def set_dry_food
      @dry_food = Current.user.dry_foods.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = t('.not_found')
      redirect_to dry_foods_path
    end

    def dryfood_params
      params.require(:dry_food).permit(:brand, :description, :amount, :used_amount)
    end
end
