class StaticPagesController < ApplicationController
  def landing_page
  end

  def privacy_policy
  end

  def homepage

    @ransack_path = courses_path
    @q = Course.ransack(params[:q])
    @popular_courses = Course.order(enrollments_count: :desc).limit(3)
    @top_rated_courses = Course.order(average_rating: :desc, created_at: :desc).limit(3)
    @latest_courses = Course.all.limit(3).order(created_at: :desc)
  end
end
