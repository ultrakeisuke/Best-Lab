FactoryBot.define do

  factory :user, class: User do
    name { 'user' }
    email { 'user@example.com' }
    affiliation { 0 }
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

end