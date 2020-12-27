class Answer < ApplicationRecord
  has_many :pictures, as: :imageable
  has_many :replies
  belongs_to :user
  belongs_to :post
end
