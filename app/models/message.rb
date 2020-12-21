class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :pictures, as: :imageable, dependent: :destroy
end
