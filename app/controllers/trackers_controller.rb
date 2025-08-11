class TrackersController < ApplicationController
  before_action :set_pet
  before_action :set_tracker, only: %i[ show edit update destroy ]
  before_action :require_authentication
  before_action :set_current_date, :set_current_time

  # GET /trackers or /trackers.json
  def index
    @trackers = @pet.trackers.paginate(page: params[:page], per_page: 10).order(date: :asc, feed_time: :asc)
  end

  # GET /trackers/1 or /trackers/1.json
  def show
    
  end

  # GET /trackers/new
  def new
    # @tracker = Tracker.new
    # @dry_food = DryFood.find(params[:dry_food_id])
    @tracker = @pet.trackers.build
    @dry_foods_count = DryFood.count
  end

  # GET /trackers/1/edit
  def edit
  end

  # POST /trackers or /trackers.json
  def create
    # @tracker = Tracker.new(tracker_params)
    # @pet = Pet.find(params[:pet_id])
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
    @tracker.update!(params.expect(tracker: [:amount, :left_amount, :hungry, :come_back_to_eat_time, :love]))
    @tracker.total_ate_amount = @tracker.amount - @tracker.left_amount
    @tracker.frequency = calculate_frequency(@tracker.come_back_to_eat_time)
    @tracker.result = [@tracker.hungry[0], @tracker.love[0]].join(" - ")
    @tracker.favorite_score = calculate_favorite([@tracker.hungry[0], @tracker.love[0]])

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

  # app/controllers/trackers_controller.rb

  def random_wet_foods
    # This finds the last 50 wet food entries and picks 5 random ones
    # We limit to 50 to keep the query efficient on a large database
    @random_wet_foods = @pet.trackers.where(food_type: 'Wet')
                                    .where("favorite_score > ?", 30)
                                    .order(created_at: :desc).limit(50).sample(5)
    
    render json: @random_wet_foods.to_json(only: [:brand, :description, :favorite_score])
  end

  def search_food
    @search_results = @pet.trackers.where('brand ILIKE ? OR description ILIKE ?', "%#{params[:query]}%", "%#{params[:query]}%").limit(10)
    render json: @search_results.to_json(only: [:brand, :description, :favorite_score])
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
      params.expect(tracker: [ :date, :feed_time, :come_back_to_eat_time, :brand, :description, :hungry, :amount, :left_amount, :result, :note, :pet_id, :weight, :total_ate_amount, :favorite_score, :frequency, :love, :transformed_date, :transformed_time, :food_type, :dry_food_id ])
    end

    def set_current_time
      Time.zone = Current.user.timezone
      Time.current.strftime("%H:%M")
    end

    def set_current_date
      Time.zone = Current.user.timezone
      Date.current.strftime("%Y-%m-%d")
    end

    def calculate_frequency(time_string)
      time_string == '-' ? 0 : time_string.split(', ').count
    end

    def calculate_favorite(arr)
      hungry = {"💖": 10, "🔺": 5, "❌": 0 }
      love = {"💕": 15,  "🔺": 5, "❌": 0}
      
      hungry_score = hungry[arr[0].to_sym]
      love_score = love[arr[1].to_sym]
      remaining_score = @tracker.left_amount < (@tracker.amount)/4 ? 15 : 8 
      frequent_score = @tracker.frequency * 2

      hungry_score.to_i + love_score.to_i + remaining_score + frequent_score
    end
end
