class Reply < ApplicationRecord
  has_many :pictures, as: :imageable
  belongs_to :user
  belongs_to :post
  belongs_to :answer
end
