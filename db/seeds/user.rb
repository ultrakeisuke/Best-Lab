# 初期ユーザーデータ
users = []
1000.times do |n|
  name = Faker::Name.name
  email = "user-#{n + 1}@example.com"
  users << User.new(name: name,
                    email: email,
                    password: ENV['INITIAL_USER_PASSWORD'],
                    password_confirmation: ENV['INITIAL_USER_PASSWORD'],
                    confirmed_at: Time.current)
end
User.import users

# ゲストユーザーとプロフィールを作成
User.create(name: 'guest',
            email: 'guest@example.com',
            password: '1234567',
            password_confirmation: '1234567',
            confirmed_at: Time.current)

# 退会済みのユーザーを作成
User.create(name: 'discard',
            email: 'discard@example.com',
            password: 'discard',
            password_confirmation: 'discard',
            confirmed_at: Time.current,
            discarded_at: Time.current + 1.second)

Admin.create(email: ENV['ADMIN_EMAIL'],
             password: ENV['ADMIN_PASSWORD'])
