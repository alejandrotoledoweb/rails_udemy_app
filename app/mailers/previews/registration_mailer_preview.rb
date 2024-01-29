class Previews::RegistrationMailerPreview < ActionMailer::Preview
  def test_email
    @user = User.first
    RegistrationMailer.test_email(@user)
  end
end
