FactoryBot.define do

  factory :admin do
    email { 'admin@example.com' }
    password { '1234567' }
  end

  sequence :users_name do |i|
    "user-#{i}"
  end

  sequence :users_email do |i|
    "user-#{i}@example.com"
  end

  factory :users, class: User do
    name { generate :users_name }
    email { generate :users_email }
    password { '1234567' }
  end
  
end
