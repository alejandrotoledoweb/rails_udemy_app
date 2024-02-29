class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]

  def index
    # @courses = Course.all.order(id: :asc)

    @ransack_path = courses_path
    @q = Course.ransack(params[:q])
    # @courses = @q.result(distinct: true).order(created_at: :desc) #before pagy
    @pagy, @courses = pagy(@q.result(distinct: true).order(created_at: :desc))
  end

  def purchased
    @ransack_path = purchased_courses_path
    @q = Course.ransack(params[:q])
    courses = @q.result.joins(:enrollments).where(enrollments: { user: current_user })
    @pagy, @courses = pagy(courses)
    render 'index'

  end

  def created
    @ransack_path = created_courses_path
    @q = Course.ransack(params[:q])
    courses = @q.result.where(  user: current_user )
    @pagy, @courses = pagy(courses)
    render 'index'
  end

  def show
    @lessons = @course.lessons
  end

  def new
    @course = Course.new
  end

  def edit
  end

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
            course: @course,
          },
        ),
      )
    end
  end

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
            course: @course,
          },
        ),
      )
    end
  end

  def destroy
    authorize @course
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_course
    @course = Course.friendly.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :description, :short_description, :language, :level, :price)
  end
end
