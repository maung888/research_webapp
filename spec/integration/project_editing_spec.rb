# spec/system/project_editing_spec.rb
require 'rails_helper'

RSpec.describe "Project Editing", type: :system do
  before do
    driven_by(:rack_test) # Or :selenium_chrome_headless

    # Mock OmniAuth (as in your project_creation_spec.rb)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: 'facultyuser123',
      info: {
        email: 'faculty@example.com',
        name: 'Test Faculty User'
      },
      credentials: {
        token: 'mock_token',
        expires_at: Time.now + 1.week
      }
    })

    # Create a faculty user and a project associated with them
    @faculty_user = User.find_or_create_by!(email: 'faculty@example.com') do |user|
      user.name = 'Test Faculty User'
      user.uid = 'facultyuser123'
      user.provider = 'google_oauth2'
    end
    @faculty = Faculty.create!(user: @faculty_user, department: 'CS')
    @project = Project.create!(
      title: "Original Project Title",
      description: "Original Description",
      num_positions: "1",
      areas_of_research: 'Original Area',
      start_semester: 'Original Semester',
      faculties: [ @faculty ]
    )

    # Log in the faculty user
    visit new_user_session_path
    click_button "Google"
    expect(page).to have_current_path(root_path)
  end

  # --- Sunny Day Scenarios ---

  scenario "Faculty user can edit their project successfully" do
    visit projects_path
    click_link "Edit"

    expect(page).to have_current_path(edit_project_path(@project))
    expect(find_field("project_title").value).to eq("Original Project Title")

    fill_in "project_title", with: "Updated Project Title"
    fill_in "project_description", with: "Updated Description"
    fill_in "project_num_positions", with: "2"
    fill_in "project_areas_of_research", with: "Updated Area" # Use the correct ID!
    fill_in "project_start_semester", with: "Updated Semester"
    click_button "Update Project"
    expect(page).to have_current_path(project_path(@project))
    expect(page).to have_selector(".alert-info", text: "Project was successfully updated.")
    expect(page).to have_selector("h1.project-title", text: "Updated Project Title")
    expect(page).to have_selector(".project-description", text: "Updated Description")
    expect(page).to have_selector("p", text: /Number of Positions:.*2/) # Check the <p> tag
    expect(page).to have_selector("p", text: /Updated Area/)
    expect(page).to have_selector("p", text: "Start Semester: Updated Semester")
    expect(page).not_to have_selector("h1.project-title", text: "Original Project Title")
  end

  scenario "Faculty user can delete their project" do
    visit project_path(@project) # Go directly to the project show page.
    click_button "Delete Project"
    expect(page).to have_current_path(projects_path)
    expect(page).to have_selector(".alert-info", text: "Project was successfully deleted.")
    expect(Project.find_by(id: @project.id)).to be_nil
  end

  # --- Rainy Day Scenarios ---

  scenario "Faculty user cannot edit another faculty's project" do
    # Create a second faculty user
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: 'facultyuser456',
        info: {
          email: 'faculty2@example.com',
          name: 'Test Faculty User 2'
        },
        credentials: {
          token: 'mock_token_2',
          expires_at: Time.now + 1.week
        }
      })
      @faculty_user2 = User.find_or_create_by!(email: 'faculty2@example.com') do |user|
        user.name = 'Test Faculty User 2'
        user.uid = 'facultyuser456'
        user.provider = 'google_oauth2'
      end
    @faculty2 = Faculty.create!(user: @faculty_user2, department: 'EE')

    # Log OUT the first faculty User
    click_link "Sign Out"
    # Log in as the second faculty user
    visit new_user_session_path
    click_button "Google"

    # Try to visit the edit page for the first user's project directly
    visit edit_project_path(@project)
    expect(page).to have_current_path(root_path) # Redirected to root, not allowed
    expect(page).to have_selector(".alert.alert-info", text: "You are not authorized to edit this project.")
  end

  scenario "Faculty user sees validation errors when editing with invalid input" do
    visit edit_project_path(@project)

    fill_in "Project Title", with: ""  # Make the title blank
    click_button "Update Project"

    expect(page).to have_selector("#error_explanation", text: "prohibited this project from being saved") # Check for error message
    expect(page).to have_selector("#error_explanation li", text: "Title can't be blank") # Check for specific validation error
  end

    scenario "Admin user can edit any project" do
        # Log out of Faculty User
        click_link "Sign Out"
        # Create an admin user
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
            provider: 'google_oauth2',
            uid: 'adminuser789',
            info: {
              email: 'admin@example.com',
              name: 'Test Admin User'
            },
            credentials: {
              token: 'mock_token_admin',
              expires_at: Time.now + 1.week
            }
          })
          @admin_user = User.find_or_create_by!(email: 'admin@example.com') do |user|
            user.name = 'Test Admin User'
            user.uid = 'adminuser789'
            user.provider = 'google_oauth2'
          end
        Admin.create!(user: @admin_user)

        # Add the admin email to your list in User.rb (temporarily or permanently)
        allow(User).to receive(:is_admin_email?).with('admin@example.com').and_return(true)


        # Log in as the admin user
        visit new_user_session_path
        click_button "Google"


        # Try to visit the edit page for the faculty user's project
        visit edit_project_path(@project)
        expect(page).to have_current_path(edit_project_path(@project)) # Allowed!

        fill_in "Project Title", with: "Updated by Admin"
        click_button "Update Project"

    expect(page).to have_selector("h1.project-title", text: "Updated by Admin")
  end

    scenario "Admin user can delete any project" do
      # Log out of Faculty User
      click_link "Sign Out"
      # Create an admin user
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
          provider: 'google_oauth2',
          uid: 'adminuser789',
          info: {
            email: 'admin@example.com',
            name: 'Test Admin User'
          },
          credentials: {
            token: 'mock_token_admin',
            expires_at: Time.now + 1.week
          }
        })
        @admin_user = User.find_or_create_by!(email: 'admin@example.com') do |user|
          user.name = 'Test Admin User'
          user.uid = 'adminuser789'
          user.provider = 'google_oauth2'
        end
      Admin.create!(user: @admin_user)

      # Add the admin email to your list in User.rb (temporarily or permanently)
      allow(User).to receive(:is_admin_email?).with('admin@example.com').and_return(true)


      # Log in as the admin user
      visit new_user_session_path
      click_button "Google"

      visit project_path(@project)
      click_button "Delete Project"

      expect(Project.find_by(id: @project.id)).to be_nil
      expect(page).to have_current_path(projects_path)
      expect(page).to have_selector(".alert-info", text: "Project was successfully deleted.")
    end
    scenario "Non-logged in user cannot access edit page" do
        click_link "Sign Out"
        visit edit_project_path(@project)
        expect(page).to have_current_path(new_user_session_path)
    end
    scenario "Non-logged in user cannot access update action" do
        click_link "Sign Out"
        page.driver.submit :patch, project_path(@project), {}
        expect(page).to have_current_path(new_user_session_path)
    end
end
