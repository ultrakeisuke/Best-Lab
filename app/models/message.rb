class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :pictures
  accepts_nested_attributes_for :pictures
end
