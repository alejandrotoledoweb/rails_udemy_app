module CoursesHelper
  require 'nokogiri'
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
            "Completed 100% -> See your certification"
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
    if current_user
      user_course = course.enrollments.where(user_id: current_user.id )
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

    full_stars.times { content += tag.i('', class: 'fa-solid fa-star text-yellow-500') }
    half_star.times { content += tag.i('', class: 'fa-regular fa-star-half-stroke text-yellow-500') }
    empty_stars.times { content += tag.i('', class: 'fa-regular fa-star text-yellow-500') }

    content.html_safe
  end

  def published(course)
    published_icon = tag.i('', class: 'fa-solid fa-check-circle text-green-500 ml-1 ')
    unpublished_icon = tag.i('', class: 'fa-regular fa-x text-red-500 ml-1 ')
    p = tag.p('Published', class: 'w-24 mr-2 inline-flex')
    up = tag.p('Unpublished', class: 'w-24 mr-2 inline-flex')
    if course.published
      p + published_icon
    else
      up + unpublished_icon
    end
  end
  def approved(course)
    approved_icon = tag.i('', class: 'fa-solid fa-check-circle text-green-500 ml-1')
    unapproved = tag.i('', class: 'fa-solid fa-x text-red-500 ml-1.5')
    p = tag.p('Approved', class: 'w-24 mr-2 inline-flex')
    up = tag.p('Unapproved', class: 'w-24 mr-2 inline-flex')
    if course.approved
      p + approved_icon
    else
      up + unapproved
    end
  end

  def admin_approve_button(course)
    return unless current_user && current_user.has_role?(:admin)

    content_tag(:p, 'Admin Actions:') +
    if course.approved
      button_to 'Unapprove', unapprove_course_path(course), method: :patch, class: "hover:underline text-blue-600"
    else
      button_to 'Approve', approve_course_path(course), method: :patch, class: "hover:underline text-blue-600"
    end
  end

end
