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
        link_to "Continue", course_path(course)
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
    user_course = course.enrollments.where(user: current_user )
    if current_user
      if course.enrollments.where(user: current_user).any?
        if user_course.where(rating:[0,nil, ""], review: [0, nil, ""]).any?
          link_to "Edit a review", edit_enrollment_path(course.enrollments.where(user:current_user).first)
        else
          "You have a review already"
        end
      end
    end
  end
end
