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
          if course.progress(current_user) < 100
            "Continue Learning #{number_to_percentage(course.progress(current_user), :precision => 0)}"
          # course.user_lessons.where(user: current_user).count
          # course.lessons_count
          else
            "See you certification"
          end
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

  def purchased_course(user, course)
    course.enrollments.where(user: user).any?
  end

  def display_star_rating(rating)
    full_stars = rating.floor
    half_star = rating.modulo(1) >= 0.5 ? 1 : 0
    empty_stars = 5 - full_stars - half_star
    content = ''

    full_stars.times { content += tag.i('', class: 'fa-solid fa-star text-yellow-300') }
    half_star.times { content += tag.i('', class: 'fa-regular fa-star-half-stroke text-yellow-300') }
    empty_stars.times { content += tag.i('', class: 'fa-regular fa-star text-yellow-300') }

    content.html_safe
  end
end
