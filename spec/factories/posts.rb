FactoryBot.define do
  factory :post, class: Post do
    title { "MyString" }
    content { "MyString" }
    status { "open" }
  end

  factory :post_form, class: PostForm do
    title { "MyString" }
    content { "MyString" }
  end
end
