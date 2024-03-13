class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ homepage ]
  def landing_page
  end

  def privacy_policy
  end

  def homepage

    @ransack_path = courses_path
    @q = Course.ransack(params[:q])
    @popular_courses = Course.popular_courses.published.approved
    @top_rated_courses = Course.top_rated_courses.published.approved
    @latest_courses = Course.latest_courses.published.approved
    @purchased_courses = Course.joins(:enrollments).where(enrollments: {user: current_user}).order(created_at: :desc).limit(3)

    @latest_good_reviews = Enrollment.reviewed.latest_reviews

    @enrollments = Enrollment.all
  end
end
