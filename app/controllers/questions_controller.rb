class QuestionsController < ApplicationController
  before_action :load_question, only: %i[destroy edit update]
  before_action :authorize_user, except: [:create]

  def create
    @question = Question.new(question_create_params)

    # Проверяем капчу вместе с сохранением вопроса. Если в капче ошибка,
    # она будет добавлена в массив @question.errors.
    if check_captcha(@question) && @question.save
      redirect_to user_path(@question.user), notice: 'Вопрос задан'
    else
      render :edit
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

  def check_captcha(model)
    current_user.present? || verify_recaptcha(model: model)
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
