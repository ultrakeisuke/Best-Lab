FactoryBot.define do
  factory :room, class: Room do
  end

  factory :rooms, class: Room do
    sequence(:id) { |n| (n + 1).to_s}
  end
end
