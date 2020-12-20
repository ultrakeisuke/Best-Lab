FactoryBot.define do
  factory :parent_category, class: Category do
    name { "parent" }
  end
  factory :children_category, class: Category do
    name { "children" }
  end
end
