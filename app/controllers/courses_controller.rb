class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    # @courses = Course.all.order(id: :asc)

    @q = Course.ransack(params[:q])
    @courses = @q.result(distinct: true).order(created_at: :desc)
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    @course.user = current_user
    authorize @course

      if @course.save
        redirect_to courses_url, notice: "Course was successfully created."
      else
        render(
          turbo_stream: turbo_stream.replace(
            "course_form",
            partial: "courses/form",
            locals: {
              course: @course
            }
            )
        )
      end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    authorize @course
    if @course.update(course_params)
        redirect_to courses_url, notice: "Course was successfully updated."
    else
      render(
        turbo_stream: turbo_stream.replace(
          "course_form",
          partial: "courses/form",
          locals: {
            course: @course
          }
          )
      )
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:title, :description, :short_description, :language, :level, :price)
    end
end
