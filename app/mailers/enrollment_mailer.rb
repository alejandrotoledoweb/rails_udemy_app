class EnrollmentMailer < ApplicationMailer
  default from: 'atoledofr@gmail.com'

  def new_enrollment(enrollment)
    @enrollment = enrollment
    @course = enrollment.course
    mail(
      to: @enrollment.user.email,
      subject: "You have enrolled to #{@course.title}"
    )
    mail(
      to: @enrollment.course.user.email,
      subject: "You have a new student from #{@course.title}"
    )

  end
end
