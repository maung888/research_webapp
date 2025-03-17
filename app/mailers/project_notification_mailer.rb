# app/mailers/project_notification_mailer.rb
class ProjectNotificationMailer < ApplicationMailer
  def new_project_email(user, project)
    @user = user
    @project = project
    mail(to: @user.email, subject: "New Research Project Available")
  end
end
