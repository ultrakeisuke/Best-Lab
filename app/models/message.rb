class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :body, length: { maximum: 10000 }, presence: true, unless: -> { pictures.present? }
  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true
end
