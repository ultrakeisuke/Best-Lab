class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :room
  include Partner
end
