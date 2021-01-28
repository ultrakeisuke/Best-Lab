users = []
10.times do |n|
  name = Faker::Name.name
  email = "user-#{n+1}@example.com"
  users << User.new(name: name,
                    email: email,
                    password: "1234567",
                    password_confirmation: "1234567",
                    confirmed_at: Time.now)
end
User.import users

profiles = []
10.times do |n|
  profiles << Profile.new(affiliation: "大学生",
                          school: "school-#{n+1}",
                          faculty: "faculty-#{n+1}",
                          department: "department-#{n+1}",
                          laboratory: "laboratory-#{n+1}",
                          content: "",
                          user_id: n+1)
end
Profile.import profiles

# ゲストユーザーとプロフィールを作成
guest_user = User.create(name: "guest",
                         email: "guest@example.com",
                         password: "1234567",
                         password_confirmation: "1234567",
                         confirmed_at: Time.now)

guest_profile = Profile.create(affiliation: "大学院生",
                               school: "ゲスト大学",
                               faculty: "ゲスト学部",
                               department: "ゲスト学科",
                               laboratory: "ゲスト研究室",
                               content: "ゲストユーザーです。",
                               user_id: guest_user.id)  

admin_user = Admin.create!(email: "admin@example.com",
                           password: "1234567")
                           