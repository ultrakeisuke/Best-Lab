FactoryBot.define do

  factory :user, class: User do
    name { 'user' }
    email { 'user@example.com' }
    password { '1234567' }
  end

  factory :another_user, class: User do
    name { 'another_user' }
    email { 'another_user@example.com' }
    password { '1234567' }
  end

  factory :guest_user, class: User do
    name { 'guest' }
    email { 'guest@example.com' }
    password { '1234567' }
  end

  factory :test_users, class: User do
    sequence(:name) {|n| "name-#{n+1}"}
    sequence(:email) {|n| "email-#{n+1}@example.com"}
    sequence(:password) {|n| "password-#{n+1}"}
  end

end
