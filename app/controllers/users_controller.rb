# Контроллер, управляющий пользователями. Должен уметь:
#
#   1. Показывать страницу пользователя.
#   2. Создавать новых пользователей.
#   3. Позволять пользователю редактировать свою страницу.
#   4. Разрешить пользователю удалить свой аккаунт.
#
class UsersController < ApplicationController
  # Загружаем юзера из базы для экшенов кроме :index, :create, :new
  before_action :load_user, except: [:create, :index, :new, :destroy]

  # Проверяем имеет ли юзер доступ к экшену, делаем это для всех действий, кроме
  # :index, :new, :create, :show — к этим действиям есть доступ у всех, даже у
  # тех, у кого вообще нет аккаунта на нашем сайте.
  before_action :authorize_user, except: [:index, :new, :create, :show, :destroy]

  def index
    @users = User.all
    @hashtags = Hashtag.with_questions
  end

  # Действие new будет отзываться по адресу /users/new
  def new
    # Если пользователь уже авторизован, ему не нужна новая учетная запись,
    # отправляем его на главную с сообщением.
    redirect_to root_path, alert: 'Вы уже залогинены' if current_user.present?

    # Иначе, создаем болванку нового пользователя.
    @user = User.new
  end

  # Действие create будет отзываться при POST-запросе по адресу /users из формы
  # нового пользователя, которая находится в шаблоне на странице /users/new.
  def create
    # Если пользователь уже авторизован, ему не нужна новая учетная запись,
    # отправляем его на главную с сообщением.
    redirect_to root_path, alert: 'Вы уже залогинены' if current_user.present?

    # Иначе, создаем нового пользователя с параметрами, которые нам предоставит
    # метод user_params.
    @user = User.new(user_params)

    # Пытаемся сохранить пользователя.
    if @user.save
      # Если удалось сохранить, то делаем пользователя авторизованым:
      session[:user_id] = @user.id

      # и отправляем на главную с сообщением, что пользователь создан.
      redirect_to root_path, notice: 'Регистрация прошла успешно!'
    else
      # Если не удалось по какой-то причине сохранить пользователя, то рисуем
      # (обратите внимание, это не редирект), страницу new с формой
      # пользователя, который у нас лежит в переменной @user. В этом объекте
      # содержатся ошибки валидации, которые выведет шаблон формы.
      render 'new'
    end
  end

  # Действие edit будет отзываться по адресу /users/:id/edit, например,
  # /users/1/edit
  #
  # Перед этим действием сработает before_action :load_user и в переменной @user
  # у нас будет лежать пользовать с нужным id равным params[:id].
  def edit
  end

  def destroy
    # Данный экшн удаляет пользователя из БД
    @user.destroy

    # Прерываем сессию
    reset_session

    # Редиректим на главную страницу с уведомлением о удалении.
    redirect_to root_path, notice: 'Пользователь удалён!'
  end

  # Действие update будет отзываться при PUT-запросе из формы редактирования
  # пользователя, которая находится по адресу /users/:id, например,
  # /users/1
  #
  # Перед этим действием сработает before_action :load_user и в переменной @user
  # у нас будет лежать пользовать с нужным id равным params[:id].
  def update
    # Аналогично create, мы получаем параметры нового (обновленного)
    # пользователя с помощью метода user_params, и пытаемся обновить @user с
    # этими значениями.
    if @user.update(user_params)
      # Если получилось, отправялем пользователя на его страницу с сообщением,
      # что пользователь успешно обновлен.
      redirect_to root_path(@user), notice: 'Данные обновлены'
    else
      # Если не получилось, как и в create рисуем страницу редактирования
      # пользователя, на которой нам будет доступен объект @user, содержащий
      # информацию об ошибках валидации, которые отобразит форма.
      render 'edit'
    end
  end

  # Это действие отзывается, когда пользователь заходит по адресу /users/:id,
  # например /users/1
  #
  # Перед этим действием сработает before_action :load_user и в переменной @user
  # у нас будет лежать пользовать с нужным id равным params[:id].
  def show
    # Достаем вопросы пользователя с помощью метода questions, который мы
    # объявили в модели User (has_many :questions), у результата возврата этого
    # метода вызываем метод order, который отсортирует вопросы по дате.
    @questions = @user.questions.order(created_at: :desc)

    # Для формы нового вопроса, которая есть у нас на странице пользователя,
    # создаем болванку вопроса, вызывая метод build у результата вызова метода
    # @user.questions.
    @new_question = @user.questions.build

    @questions_count = @questions.count
    @answers_count = @questions.where.not(answer: nil).count
    @unanswered_count = @questions_count - @answers_count
  end

  private

  # Если загруженный из базы юзер и текущий залогиненный не совпадают — посылаем
  # его с помощью описанного в контроллере ApplicationController метода
  # reject_user.
  def authorize_user
    reject_user unless @user == current_user
  end

  # Загружаем из базы запрошенного юзера, находя его по params[:id].
  def load_user
    @user ||= User.find params[:id]
  end

  # Явно задаем список разрешенных параметров для модели User. Мы говорим, что
  # у хэша params должен быть ключ :user. Значением этого ключа может быть хэш с
  # ключами: :email, :password, :password_confirmation, :name, :username и
  # :avatar_url, :color. Другие ключи будут отброшены.
  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :username, :author, :avatar_url, :color
    )
  end
end
