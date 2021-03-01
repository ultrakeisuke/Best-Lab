FactoryBot.define do
  factory :answer, class: Answer do
    body { 'answer' }
  end
  factory :answer_form, class: AnswerForm do
    body { 'answer_form' }
  end
end
