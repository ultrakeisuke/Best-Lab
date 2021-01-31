class Reply < ApplicationRecord
  has_many :pictures, as: :imageable, dependent: :destroy
  belongs_to :user
  belongs_to :post
  belongs_to :answer
end
