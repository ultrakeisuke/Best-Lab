FactoryBot.define do
  factory :entry, class: Entry do
  end

  # ログインユーザーが所有する部屋とその話し相手の情報
  factory :another_entries, class: Entry do
    sequence(:room_id) { |n| (n + 1).to_s }
  end
end
