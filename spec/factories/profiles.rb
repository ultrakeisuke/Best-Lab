FactoryBot.define do
  # ユーザーがすでに持っているprofileのテストデータ
  factory :profile, class: Profile do
    affiliation { "undergraduate" }
    school { "MyString" }
    faculty { "MyString" }
    department { "MyString" }
    laboratory { "MyString" }
    description { "MyString" }
  end

  # フォームオブジェクト用テストデータ
  factory :profile_form, class: ProfileForm do
    affiliation { "undergraduate" }
    school { "MyString" }
    faculty { "MyString" }
    department { "MyString" }
    laboratory { "MyString" }
    description { "MyString" }
  end
end
