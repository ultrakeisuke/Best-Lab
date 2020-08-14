0.upto(4) do |n|
  user = User.create(
    name: "name-#{n + 1}",
    email: "email-#{n + 1}@example.com",
    password: "password"
  )
  user.confirm
end

admin_user = User.create!(name: "admin",
                          email: "admin@example.com",
                          password: "1234567",
                          password_confirmation: "1234567",
                          admin: true)
admin_user.confirm