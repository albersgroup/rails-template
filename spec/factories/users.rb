FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    name { "Test User" }

    trait :with_sso do
      provider { "entra_id" }
      sequence(:uid) { |n| "sso-uid-#{n}" }
    end
  end
end
