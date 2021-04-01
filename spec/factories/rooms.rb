FactoryBot.define do
  factory :room, class: Room do
    id { '' }
  end

  factory :rooms, class: Room do
    sequence(:id) { |n| (n + 1).to_s}
  end
end
