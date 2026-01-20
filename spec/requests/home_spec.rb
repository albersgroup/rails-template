require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "returns a successful response" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "renders HTML content" do
      get root_path
      expect(response.content_type).to include("text/html")
    end

    it "displays the welcome heading" do
      get root_path
      expect(response.body).to include("Welcome")
    end
  end

  describe "authentication" do
    context "when user is not signed in" do
      it "shows the sign in link" do
        get root_path
        expect(response.body).to include("Sign in")
      end

      it "shows the create account link" do
        get root_path
        expect(response.body).to include("Create an account")
      end

      it "does not show sign out button" do
        get root_path
        expect(response.body).not_to include("Sign out")
      end
    end

    context "when user is signed in" do
      let(:user) { create(:user, email: "test@example.com") }

      before { sign_in user }

      it "shows the user's email" do
        get root_path
        expect(response.body).to include(user.email)
      end

      it "shows the sign out button" do
        get root_path
        expect(response.body).to include("Sign out")
      end

      it "does not show sign in link" do
        get root_path
        expect(response.body).not_to include("Sign in</a>")
      end
    end

    context "when user has a name" do
      let(:user) { create(:user, name: "John Doe") }

      before { sign_in user }

      it "shows the user's name" do
        get root_path
        expect(response.body).to include("John Doe")
      end
    end
  end
end
