module CoursesHelper
  include Pagy::Frontend

  def language_options
    %w[English Spanish French German Chinese]
  end

  def level_options
    %w[Beginner Intermediate Advanced Expert]
  end

  def enrollment_button(course)
    if current_user
      if course.user === current_user
         link_to "See Analytics", course_path(course)
      elsif course.enrollments.where(user_id: current_user.id, course_id: course.id).any?
        link_to course_path(course) do
          "Continue Learning #{number_to_percentage(course.progress(current_user), :precision => 0)}"

          # course.user_lessons.where(user: current_user).count
          # course.lessons_count
        end
      elsif course.price > 0
        link_to "Buy this course", new_course_enrollment_path(course)

      else
        link_to "Free", new_course_enrollment_path(course)

      end
      #logic to buy
    else
      # check price and buy,
      link_to "Check price", course_path(course)
    end
  end

  def review_button(course)
    user_course = course.enrollments.where(user_id: current_user.id )
    if current_user
      if user_course.any?
        if user_course.pending_review.any?
          link_to "Add review", edit_enrollment_path(course.enrollments.where(user:current_user).first)
        else
          link_to "Edit review", edit_enrollment_path(course.enrollments.where(user:current_user).first)
        end
      end
    end
  end
end
