# spec/mailers/project_notification_mailer_spec.rb
require "rails_helper"

RSpec.describe ProjectNotificationMailer, type: :mailer do
  describe "new_project_email" do
    let(:user) { User.create!(email: "student@example.com", name: "Test Student", uid: "123", provider: "test") }
    let!(:student) { Student.create!(user: user) } # Ensure the user is a student
    let(:project) do
      Project.create!(
        title: "Test Project",
        description: "This is a test project description.",
        num_positions: 2,
        areas_of_research: "Testing, Example",
        start_semester: "Fall 2024",
        prefered_class: "Graduate",
        other_comments: "Some comments"
      )
    end
    # Create Faculty so that Project does not error out.
    let(:faculty_user) { User.create!(email: 'faculty@example.com', name: 'Test Faculty User', uid: 'testuser123', provider: 'google_oauth2') }
    let!(:faculty) { Faculty.create!(user: faculty_user) }

    let(:mail) { ProjectNotificationMailer.new_project_email(user, project) }

    before do
      project.faculties << faculty_user.faculty # Associate a faculty with the project
    end

    it "renders the headers correctly" do
      expect(mail.subject).to eq("New Research Project Available")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ ENV['ZOHO_SMTP_USERNAME'] ])
    end

    it "renders the body correctly" do
      # Check for HTML part
      expect(mail.html_part.body.to_s).to match(/<h1>\s*New Research Project:\s*Test Project\s*<\/h1>/)
      expect(mail.html_part.body.to_s).to match(/Hello\s+Test Student/)
      expect(mail.html_part.body.to_s).to match(/This is a test project description\./) # Allow for punctuation
      expect(mail.html_part.body.to_s).to match(project_url(project))
      expect(mail.html_part.body.to_s).to match(/Testing,\s*Example/) # Allow for whitespace
      expect(mail.html_part.body.to_s).to match(/Fall 2024/)
      expect(mail.html_part.body.to_s).to match(/Graduate/)
      expect(mail.html_part.body.to_s).to match(/Some comments/)

      # Check for plain text part (using regular expressions)
      expect(mail.text_part.body.to_s).to match(/New Research Project:\s*Test Project/) # Allow for newline
      expect(mail.text_part.body.to_s).to match(/Hello\s+Test Student/)
      expect(mail.text_part.body.to_s).to match(/This is a test project description\./)  # Allow for punctuation
      expect(mail.text_part.body.to_s).to match(project_url(project))
      expect(mail.text_part.body.to_s).to match(/Testing,\s*Example/) # Allow for whitespace
      expect(mail.text_part.body.to_s).to match(/Fall 2024/)
      expect(mail.text_part.body.to_s).to match(/Graduate/)
      expect(mail.text_part.body.to_s).to match(/Some comments/)
    end    # Additional test: handles projects with missing optional fields

    it "handles projects with missing optional fields" do
      project = Project.create!(
        title: "Test Project 2",
        description: "Another test project.",
        num_positions: 3,
        areas_of_research: "Another Area",
        start_semester: "Spring 2025"
        # prefered_class and other_comments are *not* set
      )
        project.faculties << faculty_user.faculty
      mail = ProjectNotificationMailer.new_project_email(user, project)

      expect(mail.html_part.body.to_s).to match("Test Project 2")  # Still has the required fields
      expect(mail.html_part.body.to_s).not_to match("Preferred Class:") # These shouldn't appear
      expect(mail.html_part.body.to_s).not_to match("Other Comments:")
      expect(mail.text_part.body.to_s).to match("Test Project 2")  # Still has the required fields
      expect(mail.text_part.body.to_s).not_to match("Preferred Class:") # These shouldn't appear
      expect(mail.text_part.body.to_s).not_to match("Other Comments:")
    end
  end
end
