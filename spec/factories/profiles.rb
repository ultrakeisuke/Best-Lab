FactoryBot.define do
  factory :profile do
    affiliation { 0 }
    school { "MyString" }
    faculty { "MyString" }
    department { "MyString" }
    laboratory { "MyString" }
    content { "MyString" }
  end

  # フォームオブジェクト用テストデータ
  factory :profile_form do
    affiliation { 0 }
    school { "" }
    faculty { "" }
    department { "" }
    laboratory { "" }
    content { "" }
  end
end
