class Answer < ApplicationRecord
  has_many :pictures, as: :imageable
  has_many :replies, dependent: :destroy
  belongs_to :user
  belongs_to :post
end
