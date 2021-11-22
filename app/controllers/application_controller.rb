# Класс основного контроллера.
#
# От него мы будем наследовать контроллеры отдельных ресурсов.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  #
  # Эта строчка вызывает метод, который обеспечивает защиту от поддельных форм
  # в каждой форме есть специальный уникальный токен, который rails-приложение
  # сгенерировало специально для этой формы и который нужно отправить вместе
  # с запросом, чтобы сервер его принял.
  #
  # http://guides.rubyonrails.org/security.html#cross-site-request-forgery-csrf
  protect_from_forgery with: :exception

  # Чтобы метод current_user был доступен в шаблона, нам необходимо объявить
  # его с помощью метода helper_method. Эта строка как бы говорит рельсам:
  # если в шаблоне встретишь current_user — не пугайся, что такого метода нет,
  # дерни этот метод у контроллера.
  helper_method :current_user

  private

  # Метод контроллера, достающий текущего юзера из базы по данным аутентификации
  # в сессии.
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # Метод, который редиректит посетителя на главную с предупреждением о
  # нарушении доступа. Мы будем использовать этот метод, когда надо запретить
  # пользователю что-то.
  def reject_user
    redirect_to root_path, alert: 'Вам сюда низя!'
  end
end
