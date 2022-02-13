class QuestionsController < ApplicationController
  before_action :load_question, only: %i[destroy edit update]
  before_action :authorize_user, except: [:create]

  def create
    Questions::Create.(
      params: question_create_params,
        current_user: current_user,
        recaptcha_token: params[:recaptcha_token]
    ) do |m|
      m.failure :check_recaptcha do |result|
        redirect_to user_path(result[:question].user), notice: 'вы не прошли верификацию'
      end

      m.failure :validation do |result|
        @question = result[:question]
        render :edit
      end

      m.success do |result|
        redirect_to user_path(result[:question].user), notice: 'вопрос задан'
      end
    end
  end

  def edit
  end

  def update
    if @question.update(question_update_params)
      redirect_to user_path(@question.user), notice: 'вопрос изменён'
    else
      render :edit
    end
  end

  def destroy
    user = @question.user
    @question.destroy
    redirect_to user_path(user), notice: 'вопрос удален'
  end

  private

  def authorize_user
    reject_user unless @question.user == current_user
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_create_params
    params.require(:question).permit(:user_id, :text)
  end

  def question_update_params
    params.require(:question).permit(:answer)
  end
end
