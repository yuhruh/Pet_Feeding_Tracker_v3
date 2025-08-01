class TrackersController < ApplicationController
  before_action :set_pet
  before_action :set_tracker, only: %i[ show edit update destroy ]
  before_action :require_authentication
  before_action :set_current_date, :set_current_time

  # GET /trackers or /trackers.json
  def index
    @trackers = @pet.trackers
  end

  # GET /trackers/1 or /trackers/1.json
  def show
  end

  # GET /trackers/new
  def new
    # @tracker = Tracker.new
    @tracker = @pet.trackers.build
  end

  # GET /trackers/1/edit
  def edit
  end

  # POST /trackers or /trackers.json
  def create
    # @tracker = Tracker.new(tracker_params)
    @tracker = @pet.trackers.build(tracker_params)

    respond_to do |format|
      if @tracker.save
        format.html { redirect_to pet_trackers_path, notice: "Tracker was successfully created." }
        format.json { render :show, status: :created, location: pet_trackers_path }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trackers/1 or /trackers/1.json
  def update
    @tracker.update!(params.expect(tracker: [:amount, :left_amount, :hungry, :come_back_to_eat_time, :love, :favorite_score]))
    @tracker.total_ate_amount = @tracker.amount - @tracker.left_amount

    respond_to do |format|
      if @tracker.update(tracker_params)
        format.html { redirect_to [@pet, :trackers], notice: "Tracker was successfully updated." }
        format.json { render :show, status: :ok, location: [@pet, :trackers] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trackers/1 or /trackers/1.json
  def destroy
    @tracker.destroy!

    respond_to do |format|
      format.html { redirect_to [@pet, :trackers], status: :see_other, notice: "Tracker was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_pet
      @pet = Pet.find(params[:pet_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_tracker
      @tracker = @pet.trackers.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Tracker not found"
      redirect_to pet_tracker_path
    end

    # Only allow a list of trusted parameters through.
    def tracker_params
      params.expect(tracker: [ :date, :feed_time, :come_back_to_eat_time, :brand, :description, :hungry, :amount, :left_amount, :result, :note, :pet_id, :weight, :total_ate_amount, :favorite_score, :frequency, :love, :transformed_date, :transformed_time, :food_type ])
    end

  def set_current_time
    Time.zone = Current.user.timezone
    Time.current.strftime("%H:%M")
  end

  def set_current_date
    Time.zone = Current.user.timezone
    Date.current.strftime("%Y-%m-%d")
  end
end
