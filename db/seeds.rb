users = []
100.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  users << User.new(name: name,
                    email: email,
                    password: "1234567",
                    password_confirmation: "1234567")
end
User.import users

admin_user = Admin.create!(email: "admin@example.com",
                           password: "1234567")