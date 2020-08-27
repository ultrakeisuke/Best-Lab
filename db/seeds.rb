100.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  user = User.create(
    name: name,
    email: email,
    password: "password",
    password_confirmation: "password"
  )
  user.confirm
end

admin_user = Admin.create!(name: "admin",
                           email: "admin@example.com",
                           password: "1234567")
admin_user.confirm