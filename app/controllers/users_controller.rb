class UsersController < ApplicationController
  def index
    # Создаём массив из двух болванок пользователей. Вызываем метод # User.new, который создает модель, не записывая её в базу.
    # У каждого юзера мы прописали id, чтобы сымитировать реальную
    # ситуацию – иначе не будет работать хелпер путей
    @users = [
      User.new(
        id: 1,
        name: 'Vadim',
        username: 'installero',
        avatar_url: 'https://secure.gravatar.com/avatar/' \
        '71269686e0f757ddb4f73614f43ae445?s=100'
      ),
      User.new(id: 2, name: 'Misha', username: 'aristofun')
    ]
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
      name: 'Vadim',
      username: 'installero',
      avatar_url: ''
    )

    @questions = [
      Question.new(text: 'Как дела?', created_at: Date.parse('18.11.2021')),
      Question.new(text: 'В чём смысл жизни?', created_at: Date.parse('18.11.2021'))
    ]

    @new_question = Question.new
  end
end
