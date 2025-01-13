# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
<<<<<<< HEAD
User.find_or_create_by!(email: "Destiny@Desiree.com") do |user|
  user.password = "Fire@Me"
  user.password_confirmation = "Fire@Me"
  user.admin = true
end
=======
>>>>>>> 6b8a898766600ddf024c5fe77c0f32253f4e97c9
