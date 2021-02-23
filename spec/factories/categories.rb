FactoryBot.define do

  # 親カテゴリー
  factory :parent_category, class: Category do
    name { "parent" }
  end

  # 子カテゴリー
  factory :children_category, class: Category do
    name { "children" }
  end

  # 複数の子カテゴリー
  factory :children_categories, class: Category do
    sequence(:name) { |n| "children#{n}" }
  end

end
