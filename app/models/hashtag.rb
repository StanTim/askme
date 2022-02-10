class Hashtag < ApplicationRecord
  validates :text, uniqueness: true, presence: true
end