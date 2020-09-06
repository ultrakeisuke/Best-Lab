users = []
2.times do |n|
  name = Faker::Name.name
  email = "user-#{n+1}@example.com"
  users << User.new(name: name,
                    email: email,
                    password: "1234567",
                    password_confirmation: "1234567",
                    confirmed_at: Time.now)
end
User.import users

admin_user = Admin.create!(email: "admin@example.com",
                           password: "1234567")

rooms = []
1.times do |n|
  rooms << Room.new
end
Room.import rooms

entries = []
2.times do |n|
  entries << Entry.new(user_id: "#{n+1}",
                       room_id: "1")
end
Entry.import entries