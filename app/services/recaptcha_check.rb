module RecaptchaCheck
  class << self
    RECAPTCHA_MINIMUM_SCORE = 0.5

    def not_bot?(token, recaptcha_action)
      uri = URI.parse(
        "https://www.google.com/recaptcha/api/siteverify?secret=#{ENV['RECAPTCHA_SECRET_KEY']}&response=#{token}"
      )

      response = Net::HTTP.get_response(uri)
      json = JSON.parse(response.body)
      json['success'] && json['score'] > RECAPTCHA_MINIMUM_SCORE && json['action'] == recaptcha_action
    end
  end
end
