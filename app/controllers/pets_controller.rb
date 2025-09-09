class PetsController < ApplicationController
  before_action :set_pet, only: %i[ show edit update destroy ]
  before_action :require_authentication

  # GET /pets or /pets.json
  def index
    # @pets = Pet.all
    @pets = Current.user.pets.paginate(page: params[:page], per_page: 5)
  end

  # GET /pets/1 or /pets/1.json
  def show
  end

  # GET /pets/new
  def new
    # @pet = Pet.new
    @pet = Current.user.pets.build
  end

  # GET /pets/1/edit
  def edit
  end

  # POST /pets or /pets.json
  def create
    # @pet = Pet.new(pet_params)
    @pet = Current.user.pets.build(pet_params)

    respond_to do |format|
      if @pet.save
        format.html { redirect_to @pet, notice: t('.create_success') }
        format.json { render :show, status: :created, location: @pet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pets/1 or /pets/1.json
  def update
    respond_to do |format|
      if @pet.update(pet_params)
        format.html { redirect_to @pet, notice: t('.update_success', petname: @pet.petname) }
        format.json { render :show, status: :ok, location: @pet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1 or /pets/1.json
  def destroy
    name = @pet.petname
    @pet.destroy!

    respond_to do |format|
      format.html { redirect_to pets_path, status: :see_other, notice: t('.destroy_success', petname: name) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pet
      @pet = Pet.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def pet_params
      params.expect(pet: [ :petname, :birthday, :weight, :gender, :breed, :user_id ])
    end
end
