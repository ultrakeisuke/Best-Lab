# 0.upto(4) do |n|
#   user = User.create(
#     name: "name-#{n + 1}",
#     email: "email-#{n + 1}@test.com",
#     password: "password",
#     password_confirmation: "password"
#   )
#   user.skip_confirmation!
#   user.save!
# end