users = []
10.times do |n|
  name = Faker::Name.name
  email = "user-#{n + 1}@example.com"
  users << User.new(name: name,
                    email: email,
                    password: 'password',
                    password_confirmation: 'password',
                    confirmed_at: Time.current)
end
User.import users

profiles = []
10.times do |n|
  profiles << Profile.new(affiliation: 'graduate',
                          school: "school-#{n + 1}",
                          faculty: "faculty-#{n + 1}",
                          department: "department-#{n + 1}",
                          laboratory: "laboratory-#{n + 1}",
                          description: '',
                          user_id: n + 1)
end
Profile.import profiles

# ゲストユーザーとプロフィールを作成
User.create(name: 'guest',
            email: 'guest@example.com',
            password: '1234567',
            password_confirmation: '1234567',
            confirmed_at: Time.current)

Profile.create(affiliation: 'undergraduate',
               school: 'ゲスト大学',
               faculty: 'ゲスト学部',
               department: 'ゲスト学科',
               laboratory: 'ゲスト研究室',
               description: 'ゲストユーザーです。',
               user_id: guest_user.id)

# 退会済みのユーザーを作成
User.create(name: 'discard',
            email: 'discard@example.com',
            password: 'discard',
            password_confirmation: 'discard',
            confirmed_at: Time.current,
            discarded_at: Time.current + 1.second)

Admin.create(email: ENV['ADMIN_EMAIL'],
             password: ENV['ADMIN_PASSWORD'])
