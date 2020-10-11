FactoryBot.define do
  factory :entry, class: Entry do
  end

  factory :current_entries, class: Entry do
    sequence(:room_id) {|n| "#{n+1}"}
  end

end
