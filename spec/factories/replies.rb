FactoryBot.define do
  factory :reply, class: Reply do
    body { "reply" }
  end
  factory :reply_form, class: ReplyForm do
    body { "reply_form" }
  end
end
