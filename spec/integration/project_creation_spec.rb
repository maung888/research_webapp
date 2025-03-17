require 'rails_helper'

RSpec.describe "Project Creations", type: :system do # Changed to RSpec.describe for clarity, type: :system is key
  before do
    driven_by(:rack_test) # Or :selenium_chrome_headless if you want to test in a browser

    # Configure OmniAuth for testing - Mock the Google OAuth response
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: 'testuser123', # Example UID
      info: {
        email: 'faculty@example.com', # Use a faculty email to test faculty project creation
        name: 'Test Faculty User'
        # image: '...' # You can add image if needed
      },
      credentials: {
        token: 'mock_token',
        expires_at: Time.now + 1.week
      }
    })

    # Create a faculty user in the database (if needed for your test setup)
    @faculty_user = User.find_or_create_by!(email: 'faculty@example.com') do |user|
      user.name = 'Test Faculty User'
      user.uid = 'testuser123'
      user.provider = 'google_oauth2'
    end
    Faculty.find_or_create_by!(user: @faculty_user, department: 'Computer Science')

    # Simulate OAuth login by visiting the callback URL directly
    visit new_user_session_path # Go to the sign-in page
    click_button "Google" # Click the actual sign-in link/button

    expect(page).to have_current_path(root_path) # Expect redirect to root after login
  end

  # spec/integration/project_creation_spec.rb
  # spec/integration/project_creation_spec.rb
  scenario "Faculty user can create a new research project with valid input" do
    visit new_project_path

    fill_in "project_title", with: "Innovative Research Project System Test" # Use ID
    fill_in "project_description", with: "This is a system test project description." # Use ID
    fill_in "project_num_positions", with: "2" # Use ID
    fill_in "project_areas_of_research", with: "System Testing, Integration" # Use ID
    fill_in "project_start_semester", with: "Fall 2025" # Use ID
    fill_in "project_prefered_class", with: "Graduate" # Use ID
    fill_in "project_other_comments", with: "System test project comments" # Use ID

    click_button "Create Project"

    # Check for the flash message *and* the project content on the show page
    expect(page).to have_selector(".alert.alert-info", text: "Project was successfully created.")
    expect(page).to have_selector("h1.project-title", text: "Innovative Research Project System Test")
    expect(page).to have_selector(".project-description", text: "This is a system test project description.")
  end

  scenario "Faculty user cannot create a project with invalid input" do
    visit new_project_path

    click_button "Create Project" # Submit with empty form

    expect(page).to have_content("prohibited this project from being saved")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Num positions can't be blank")
    expect(page).to have_content("Areas of research can't be blank")
    expect(page).to have_content("Start semester can't be blank")
  end

  # spec/integration/project_creation_spec.rb
  scenario "Faculty user can find a project by searching for its details" do
    project = Project.create!(
      title: "Project to Find",
      description: "This project will be searched for.",
      num_positions: 1,
      areas_of_research: "Some topic",
      start_semester: "Mornin",
      prefered_class: "Children",
      other_comments: "Children",
    )
    project.faculties << @faculty_user.faculty # Add this line!
    visit projects_path

    fill_in "search", with: "Some topic" # Use the ID, and lowercase 'search'
    click_button "Search"

    save_and_open_page # Add this!

    expect(page).to have_selector("span.project-description", text: "This project will be searched for.")
  end

  # You can add more scenarios, e.g., testing validation limits, etc.
end
