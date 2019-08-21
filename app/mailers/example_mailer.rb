class ExampleMailer < ApplicationMailer
  default from: 'noreply@company.com'
  layout 'sample_email'

  def sample_email(user)
    @name = user.first_name
    mail to: user.email, subject: 'sample email for test'
  end

end
