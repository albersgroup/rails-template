require 'rails_helper'

RSpec.describe "Devise Sessions", type: :request do
  describe "GET /users/sign_in" do
    it "returns a successful response" do
      get new_user_session_path
      expect(response).to have_http_status(:success)
    end

    it "renders the sign in form" do
      get new_user_session_path
      expect(response.body).to include("Sign in to your account")
      expect(response.body).to include("Email")
      expect(response.body).to include("Password")
    end

    it "includes a link to create an account" do
      get new_user_session_path
      expect(response.body).to include("Create an account")
    end

    it "includes a link to reset password" do
      get new_user_session_path
      expect(response.body).to include("Forgot your password?")
    end
  end

  describe "POST /users/sign_in" do
    let(:user) { create(:user, password: "password123") }

    context "with valid credentials" do
      it "signs in the user" do
        post user_session_path, params: {
          user: { email: user.email, password: "password123" }
        }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include(user.email)
      end
    end

    context "with invalid credentials" do
      it "does not sign in the user" do
        post user_session_path, params: {
          user: { email: user.email, password: "wrongpassword" }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /users/sign_out" do
    let(:user) { create(:user) }

    before { sign_in user }

    it "signs out the user" do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end
end
