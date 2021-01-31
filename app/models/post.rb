class Post < ApplicationRecord
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :replies, dependent: :destroy
  belongs_to :user
  belongs_to :category
end
