class Profile < ApplicationRecord
  belongs_to :user
  # 所属を大学生、大学院生、高専生、専門学生、社会人、その他に分類
  enum affiliation: %i[undergraduate graduate technical_college college working the_others]
end
