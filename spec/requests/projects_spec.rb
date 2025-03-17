require 'rails_helper'

RSpec.describe "Projects", type: :request do
  before do
    # Mock OmniAuth for request spec
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: 'testuser123',
      info: {
        email: 'faculty@example.com',
        name: 'Test Faculty User'
      },
      credentials: {
        token: 'mock_token',
        expires_at: Time.now + 1.week
      }
    })

    # Create and authenticate faculty user
    @faculty_user = User.find_or_create_by!(email: 'faculty@example.com') do |user|
      user.name = 'Test Faculty User'
      user.uid = 'testuser123'
      user.provider = 'google_oauth2'
    end
    Faculty.find_or_create_by!(user: @faculty_user, department: 'Computer Science')

    # Simulate login by setting session
    post user_google_oauth2_omniauth_callback_path # Simulates OAuth login
    follow_redirect! # Follow the redirect after login
  end

  # spec/requests/projects_spec.rb
  describe "GET /" do
    it "returns http success when logged in" do
      get root_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Research Opportunities") # Changed to "Opportunities"
    end
  end
end
