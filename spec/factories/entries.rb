FactoryBot.define do
  factory :entry, class: Entry do
    user { 1 }
    room { 1 }
  end
end
