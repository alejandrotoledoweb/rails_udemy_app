# require 'pry'
class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[ show edit update destroy certification]
  before_action :set_course, only: %i[new certification]
  skip_before_action :authenticate_user!, only: %i[certification]

  def index
    @ransack_path = enrollments_path
    @q = Enrollment.ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result(distinct: true).includes(:course).order(created_at: :desc))
    authorize @enrollments
  end

  def my_students
    @ransack_path = my_students_enrollments_path
    @q = Enrollment.ransack(params[:q])
    enrollments = @q.result.joins(:course).where(courses: {user: current_user })
    @pagy, @enrollments = pagy(enrollments)
    render 'index'
  end

  def certification
    if @course.progress(current_user) < 100
      redirect_to course_path(@course)
      return
    end

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@enrollment.course.title}, #{@enrollment.user.name}",
        template: "enrollments/certificate",
        formats: [:pdf],
        orientation: "Landscape",
        lowquality: true,
        zoom: 1,
        dpi: 75
      end
    end
  end

  def show

  end

  def new
    @enrollment = Enrollment.new
  end

  def edit
    authorize @enrollment
  end

  def create
    @course = Course.friendly.find(params[:enrollment][:course_id])

    if @course.price > 0
      redirect_to new_course_enrollment_path(@course), notice: "You can't access paid courses yet."

    else
      @enrollment = current_user.buy_course(@course)
      redirect_to course_path(@course), notice: "Successfully enrolled the course!"
      EnrollmentMailer.new_enrollment(@enrollment).deliver_later
    end
  end

  def update
    authorize @enrollment
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to course_path(@enrollment.course), notice: "Review was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @enrollment
    @enrollment.destroy!

    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def set_enrollment
    # binding.pry
    @enrollment = Enrollment.find(params[:id])
  end

  def enrollment_params
    params.require(:enrollment).permit(:course_id, :user_id, :rating, :review)
  end
end
