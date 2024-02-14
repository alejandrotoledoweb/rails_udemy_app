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
         link_to "See Analytics", course_path(course), class: "rounded-lg py-1 mb-2 px-3 bg-lime-100 font-medium mr-2 hover:bg-lime-300"
      elsif course.enrollments.where(user: current_user).any?
        link_to "Continue", course_path(course), class: "rounded-lg py-1 mb-2 px-3 bg-lime-100 font-medium mr-2 hover:bg-lime-300"
      elsif course.price > 0
        link_to "Buy this course", new_course_enrollment_path(course), class: "rounded-lg py-1 mb-2 px-3 bg-lime-100 font-medium mr-2 hover:bg-lime-300"

      else
        link_to "Free", new_course_enrollment_path(course), class: "rounded-lg py-1 mb-2 px-3 bg-lime-100 font-medium mr-2 hover:bg-lime-300"

      end
      #logic to buy
    else
      # check price and buy,
      link_to "Check price", course_path(course)
    end
  end
end
