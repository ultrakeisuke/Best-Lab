FactoryBot.define do
  # ユーザーがすでに持っているprofileのテストデータ
  factory :profile, class: Profile do
    affiliation { "大学生" }
    school { "MyString" }
    faculty { "MyString" }
    department { "MyString" }
    laboratory { "MyString" }
    content { "MyString" }
  end

  # フォームオブジェクト用テストデータ
  factory :profile_form, class: ProfileForm do
    affiliation { "大学生" }
    school { "MyString" }
    faculty { "MyString" }
    department { "MyString" }
    laboratory { "MyString" }
    content { "MyString" }
  end
end
