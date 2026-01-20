require 'rails_helper'

RSpec.describe "Devise Passwords", type: :request do
  describe "GET /users/password/new" do
    it "returns a successful response" do
      get new_user_password_path
      expect(response).to have_http_status(:success)
    end

    it "renders the password reset form" do
      get new_user_password_path
      expect(response.body).to include("Forgot your password?")
      expect(response.body).to include("Email")
      expect(response.body).to include("Send reset instructions")
    end

    it "includes a link back to sign in" do
      get new_user_password_path
      expect(response.body).to include("Back to sign in")
    end
  end

  describe "POST /users/password" do
    let!(:user) { create(:user, email: "forgot@example.com") }

    it "sends password reset instructions for existing user" do
      expect {
        post user_password_path, params: { user: { email: user.email } }
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "redirects after sending instructions" do
      post user_password_path, params: { user: { email: user.email } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "shows error for non-existent email" do
      post user_password_path, params: { user: { email: "nonexistent@example.com" } }
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Email")
    end
  end
end
