FactoryBot.define do
  factory :message, class: Message do
    body { 'MyString' }
  end

  factory :message_form, class: MessageForm do
  end
end
