class HashtagsController < ApplicationController
  def show
    hashtag = Hashtag.with_questions.find_by!(params[:text])
    @questions = hashtag.questions
  end
end
