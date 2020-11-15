class Profile < ApplicationRecord
  belongs_to :user
  # 所属を大学生、大学院生、高専生、専門学生、社会人、その他に分類
  enum affiliation: %i[undergraduate graduate technical_college college working the_others]
  validates :school,     length: { maximum: 50 }
  validates :faculty,    length: { maximum: 50 }
  validates :department, length: { maximum: 50 }
  validates :laboratory, length: { maximum: 50 }
  validates :content,    length: { maximum: 200 }
end
