# (c) goodprogrammer.ru

# Модель вопроса.
class Question < ActiveRecord::Base
  belongs_to :user

  validates :user, :text, presence: true
end
