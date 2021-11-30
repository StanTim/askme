# Модель вопроса.
class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User'

  validates :text, presence: true, length: { minimum: 3, maximum: 255 }
end
