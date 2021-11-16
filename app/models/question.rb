class Question < ApplicationRecord

  belongs_to :user

  validates :text, presence: true
  validates :text, length: { maximum: 255 }

  # Демонстрация жизненного цикла объекта
  # колбэки
  # before_validation :before_validation
  # after_validation :after_validation
  # before_save :before_save
  # before_create :before_create
  # after_create :after_create
  # after_save :after_save
  #
  # before_update :before_update
  # after_update :after_update
  #
  # before_destroy :before_destroy
  # after_destroy :after_destroy
  #
  # private
end
