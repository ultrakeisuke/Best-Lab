FactoryBot.define do
  factory :message, class: Message do
    user { 1 }
    room { 1 }
    body { "MyText" }
  end
end
