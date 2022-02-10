class Hashtag < ApplicationRecord
  REGEXP = /#[[:word:]-]+/

  validates :text, uniqueness: true, presence: true
end