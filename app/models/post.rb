class Post < ApplicationRecord
  has_many :pictures
  has_many :replies
  belongs_to :user
  belongs_to :category
end
