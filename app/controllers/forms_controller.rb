class FormsController < ApplicationController
    def send_form
      project = Project.find(params[:project_id]) # Assuming project ID is passed in params
      recipient_emails = project.faculties.map { |f| f.user.email } # Extract emails from project
      form_link = "https://forms.gle/to1gTqYj2qYGm9or8"

      recipient_emails.each do |email|
        FormMailer.send_form(email, form_link).deliver_now
      end

      redirect_to root_path, notice: "Form sent successfully!"
    end
end
