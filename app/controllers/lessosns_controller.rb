class LessosnsController < ApplicationController
  before_action :set_lessosn, only: %i[ show edit update destroy ]

  # GET /lessosns or /lessosns.json
  def index
    @lessosns = Lessosn.all
  end

  # GET /lessosns/1 or /lessosns/1.json
  def show
  end

  # GET /lessosns/new
  def new
    @lessosn = Lessosn.new
  end

  # GET /lessosns/1/edit
  def edit
  end

  # POST /lessosns or /lessosns.json
  def create
    @lessosn = Lessosn.new(lessosn_params)

    respond_to do |format|
      if @lessosn.save
        format.html { redirect_to lessosn_url(@lessosn), notice: "Lessosn was successfully created." }
        format.json { render :show, status: :created, location: @lessosn }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lessosn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessosns/1 or /lessosns/1.json
  def update
    respond_to do |format|
      if @lessosn.update(lessosn_params)
        format.html { redirect_to lessosn_url(@lessosn), notice: "Lessosn was successfully updated." }
        format.json { render :show, status: :ok, location: @lessosn }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lessosn.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessosns/1 or /lessosns/1.json
  def destroy
    @lessosn.destroy!

    respond_to do |format|
      format.html { redirect_to lessosns_url, notice: "Lessosn was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lessosn
      @lessosn = Lessosn.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lessosn_params
      params.require(:lessosn).permit(:title, :content, :course_id)
    end
end
