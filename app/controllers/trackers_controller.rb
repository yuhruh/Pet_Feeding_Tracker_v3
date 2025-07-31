class TrackersController < ApplicationController
  before_action :set_pet
  before_action :set_tracker, only: %i[ show edit update destroy ]
  before_action :require_authentication
  before_action :set_current_date, :set_current_time

  # GET /trackers or /trackers.json
  def index
    @trackers = Tracker.all
  end

  # GET /trackers/1 or /trackers/1.json
  def show
  end

  # GET /trackers/new
  def new
    @tracker = Tracker.new
  end

  # GET /trackers/1/edit
  def edit
  end

  # POST /trackers or /trackers.json
  def create
    @tracker = Tracker.new(tracker_params)

    respond_to do |format|
      if @tracker.save
        format.html { redirect_to @tracker, notice: "Tracker was successfully created." }
        format.json { render :show, status: :created, location: @tracker }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trackers/1 or /trackers/1.json
  def update
    respond_to do |format|
      if @tracker.update(tracker_params)
        format.html { redirect_to @tracker, notice: "Tracker was successfully updated." }
        format.json { render :show, status: :ok, location: @tracker }
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
      format.html { redirect_to trackers_path, status: :see_other, notice: "Tracker was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_pet
      @pet = Pet.find(params[:pet_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_tracker
      @tracker = Tracker.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tracker_params
      params.expect(tracker: [ :date, :feed_time, :come_back_to_eat_time, :brand, :description, :hungry, :amount, :left_amount, :result, :note, :pet_id, :weight, :total_ate_amount, :favorite_score, :frequency, :love, :transformed_date, :transformed_time ])
    end

    def set_current_time
      Time.zone = current_user.time_zone
      Time.current.strftime("%H:%M")
    end

    def set_current_date
      Time.zone = current_user.time_zone
      Date.current.strftime("%Y-%m-%d")
    end
end
