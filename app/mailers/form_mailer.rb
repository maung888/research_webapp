class FormMailer < ApplicationMailer
    default from: "your-email@gmail.com" # Replace with your email

    def send_form(form_link)
      recipient_email = "recipient@example.com" # Hardcoded email
      @form_link = form_link
      mail(to: recipient_email, subject: "New Form Submission")
    end
end
