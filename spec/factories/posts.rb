FactoryBot.define do
  factory :post, class: Post do
    title { "MyString" }
    content { "MyString" }
    status { "受付中" }
  end

  factory :post_form, class: PostForm do
    title { "MyString" }
    content { "MyString" }
  end
end
