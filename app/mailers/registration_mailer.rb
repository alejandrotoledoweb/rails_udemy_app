class RegistrationMailer < ApplicationMailer
  def test_email(user)
    mail(
      to: user.email,
      subject: "Test Email from Rails",
      body: "This is a test email."
    )
  end
end
