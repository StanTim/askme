require 'openssl'
require 'uri'

class User < ApplicationRecord
  # Параметры алгоритма шифрования
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new
  MAX_NAME_LENGTH = 40

  attr_accessor :password

  before_validation :downcase_attributes

  validates :username,
            allow_nil: false,
            presence: true,
            uniqueness: true,
            length: { maximum: MAX_NAME_LENGTH },
            format: { with: /\A[a-zA-Z]+\z/ }

  validates :email,
            presence: true,
            allow_nil: false,
            uniqueness: true,
            format: URI::MailTo::EMAIL_REGEXP

  validates :avatar_url,
            format: URI::regexp(%w[http https ftp]),
            allow_blank: true,
            on: :update

  validates_confirmation_of :password

  before_save :encrypt_password

  has_many :questions, dependent: :destroy

  # Служебный метод, преобразующий строку в 16-ричный формат для удобства хранения
  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  # Основной метод для аутентификации юзера (логина). Проверяет email и пароль,
  # если пользователь с такой комбинацией есть в базе, возвращает этого
  # пользователя. Если нет — возвращает nil.
  def self.authenticate(email, password)
    # Сперва находим кандидата по email
    user = find_by(email: email)

    # Формируем хэш пароля из того, что передали в метод
    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )

    # Обратите внимание: сравнивается password_hash, а оригинальный пароль так
    # никогда и не сохраняется нигде. Если пароли совпали, возвращаем
    # пользователя.
    return user if user.password_hash == hashed_password

    # Иначе, возвращаем nil
    nil
  end

  private

  # Двуфакторная шифровка пароля в случае утери базы данных.
  def encrypt_password
    if self.password.present?
      # создаем соль - рандомная строка усложняющая задачу хакерам
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      # Создаём хэш пароля - длинная уникальная строка1. из которой невозможно восстановить исх. пароль.
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end

  # Приводит параметры внутри метода в нижний регистр.
  def downcase_attributes
    username&.downcase!
    email&.downcase!
  end
end
