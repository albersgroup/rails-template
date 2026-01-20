require 'rails_helper'

RSpec.describe "Devise Registrations", type: :request do
  describe "GET /users/sign_up" do
    it "returns a successful response" do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end

    it "renders the registration form" do
      get new_user_registration_path
      expect(response.body).to include("Create your account")
      expect(response.body).to include("Name")
      expect(response.body).to include("Email")
      expect(response.body).to include("Password")
    end

    it "includes a link to sign in" do
      get new_user_registration_path
      expect(response.body).to include("Already have an account?")
      expect(response.body).to include("Sign in")
    end
  end

  describe "POST /users" do
    context "with valid params" do
      let(:valid_params) do
        {
          user: {
            name: "Test User",
            email: "newuser@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      end

      it "creates a new user" do
        expect {
          post user_registration_path, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "sets the user name" do
        post user_registration_path, params: valid_params
        expect(User.last.name).to eq("Test User")
      end

      it "signs in the user after registration" do
        post user_registration_path, params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      it "does not create a user with invalid email" do
        expect {
          post user_registration_path, params: {
            user: {
              email: "invalid",
              password: "password123",
              password_confirmation: "password123"
            }
          }
        }.not_to change(User, :count)
      end

      it "does not create a user with mismatched passwords" do
        expect {
          post user_registration_path, params: {
            user: {
              email: "test@example.com",
              password: "password123",
              password_confirmation: "different"
            }
          }
        }.not_to change(User, :count)
      end

      it "does not create a user with short password" do
        expect {
          post user_registration_path, params: {
            user: {
              email: "test@example.com",
              password: "short",
              password_confirmation: "short"
            }
          }
        }.not_to change(User, :count)
      end
    end
  end
end
