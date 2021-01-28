class Post < ApplicationRecord
  has_many :pictures, as: :imageable
  has_many :answers
  has_many :replies
  belongs_to :user
  belongs_to :category
end