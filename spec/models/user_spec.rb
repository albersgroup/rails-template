require 'rails_helper'

RSpec.describe User, type: :model do
  describe "factory" do
    it "creates a valid user" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "creates a valid SSO user" do
      user = build(:user, :with_sso)
      expect(user).to be_valid
      expect(user.provider).to eq("entra_id")
    end
  end

  describe "validations" do
    it "requires an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "requires a unique email" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "requires a valid email format" do
      user = build(:user, email: "invalid-email")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it "requires a password of at least 6 characters" do
      user = build(:user, password: "12345")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it "allows a name to be optional" do
      user = build(:user, name: nil)
      expect(user).to be_valid
    end

    it "allows a name to be set" do
      user = build(:user, name: "Test User")
      expect(user).to be_valid
      expect(user.name).to eq("Test User")
    end
  end

  describe ".from_omniauth" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: "entra_id",
        uid: "12345",
        info: {
          email: "sso@example.com",
          name: "SSO User"
        }
      )
    end

    it "creates a new user from OAuth data" do
      expect {
        User.from_omniauth(auth)
      }.to change(User, :count).by(1)
    end

    it "sets user attributes from OAuth data" do
      user = User.from_omniauth(auth)

      expect(user.provider).to eq("entra_id")
      expect(user.uid).to eq("12345")
      expect(user.email).to eq("sso@example.com")
      expect(user.name).to eq("SSO User")
    end

    it "returns existing user if already registered" do
      existing_user = User.from_omniauth(auth)

      expect {
        User.from_omniauth(auth)
      }.not_to change(User, :count)

      expect(User.from_omniauth(auth)).to eq(existing_user)
    end

    it "generates a random password for OAuth users" do
      user = User.from_omniauth(auth)
      expect(user.encrypted_password).to be_present
    end
  end

  describe "devise modules" do
    it "includes database_authenticatable" do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it "includes registerable" do
      expect(User.devise_modules).to include(:registerable)
    end

    it "includes recoverable" do
      expect(User.devise_modules).to include(:recoverable)
    end

    it "includes rememberable" do
      expect(User.devise_modules).to include(:rememberable)
    end

    it "includes validatable" do
      expect(User.devise_modules).to include(:validatable)
    end
  end
end
