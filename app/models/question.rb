# Модель вопроса.
class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :author, class_name: 'User'

  validates :text, presence: true, length: { maximum: 255 }
  validates :user, :text, presence: true
end
