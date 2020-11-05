class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :pictures, dependent: :destroy
end
