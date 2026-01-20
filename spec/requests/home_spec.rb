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
  end

  describe "authentication" do
    context "when user is not signed in" do
      it "shows the sign in link" do
        get root_path
        expect(response.body).to include("Sign in")
      end
    end

    context "when user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it "shows the user's email" do
        get root_path
        expect(response.body).to include(user.email)
      end
    end
  end
end
