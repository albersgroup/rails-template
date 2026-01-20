# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create a default development user
if Rails.env.development?
  User.find_or_create_by!(email: "dev@example.com") do |user|
    user.password = "password"
    user.password_confirmation = "password"
    user.name = "Dev User"
  end

  puts "Development user created: dev@example.com / password"
end
