class ApplicationMailer < ActionMailer::Base
  default from: ENV["ZOHO_SMTP_USERNAME"] # Use the environment variable
  layout "mailer"
end
