module Questions
  class Create < BaseTransaction
    step :build_model
    step :recaptcha_check
    step :validation
    step :persistence

    def build_model(input)
      question = Question.new(author: input[:current_user], **input[:params])

      Success(input.merge(question: question))
    end

    def check_recaptcha(input)
      if input[:current_user].present? || RecaptchaCheck.not_bot?(input[:recaptcha_token], 'question')
        Success(input)
      else
        Failure(input)
      end
    end

    def validation(input)
      if input[:question].valid?
        Success(input)
      else
        Failure(input)
      end
    end

    def persistence(input)
      QuestionSave.(input[:question])

      Success(input)
    end
  end
end
