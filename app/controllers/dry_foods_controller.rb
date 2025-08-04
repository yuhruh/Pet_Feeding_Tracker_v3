class DryFoodsController < ApplicationController
  before_action :set_dry_food, only: %i[ show ]
  def index
    @dry_foods = DryFood.all
  end

  def show
  end

  def new
    @dry_food = DryFood.build
  end


  def create
    @dry_food = DryFood.new(dryfood_params)

    respond_to do |format|
      if @dry_food.save
        format.html { redirect_to dry_foods_path, notice: "Dry Food was successfully created." }
        format.json { render :show, status: :created, location: dry_foods_path }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dry_food.errors, status: :unprocessable_entity }
      end
    end
  end


  private

    def set_dry_food
      @dry_food = DryFood.find(params.expect(:id))
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Dry Food not found."
      redirect_to dry_foods_path
    end

    def dryfood_params
      params.require(:dry_food).permit(:brand, :description, :amount)
    end
end
