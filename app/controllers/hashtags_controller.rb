class HashtagController < ApplicationController
  def show
    @hashtag = Hashtag.find_by!(text: params[:text])
    @questions = @hashtag.questions
  end
end