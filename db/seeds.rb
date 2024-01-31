# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.find_or_create_by!(email: 'admin@gmail.com') do |user|
  user.password = 'admin123456'
  user.password_confirmation = 'admin123456'
  user.add_role :admin
end
User.find_or_create_by!(email: 'atoledofr@gmail.com') do |user|
  user.password = 'admin123456'
  user.password_confirmation = 'admin123456'
  user.add_role :admin
end

puts 'User Created'
puts User.first
puts User.first.id

puts "users created"

user_id = User.first.id

levels = ["Beginner", "Intermediate", "Advanced"]
languages = ["English", "Spanish", "Irish"]



30.times do
  title = Faker::Educator.course_name
  Course.find_or_create_by!(title: title) do |course|
    course.description = Faker::TvShows::GameOfThrones.quote
    course.user_id = user_id
    course.short_description = Faker::TvShows::GameOfThrones.quote
    course.language= languages.sample
    course.level = levels.sample
    course.price = Faker::Number.between(from: 100, to: 300)
  end
end
