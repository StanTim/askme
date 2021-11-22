# Модуль хэлпера ApplicationHelper
#
# В этом файле мы можем писать вспомогательные методы (хелперы) для шаблонов,
# (представлений, вьюх) нашего приложения
module ApplicationHelper
  # Этот метод возвращает ссылку на автарку пользователя, если она у него есть
  # или ссылку на дефолтную аватарку, которая лежит в app/assets/images
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  # Хелпер, рисующий span тэг с иконкой из font-awesome
  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  # class Sklonjator
  # В список параметров метода добавим ещё один параметр, причем запишем его
  # вместе с «дефолтным» значением — если метод будет вызван без этого
  # последнего параметра, то в него будет записано false.
  def sklonenie(number, one, few, many, with_number = false)
    number = 0 if number.nil? || !number.is_a?(Numeric)

    prefix = with_number ? "#{number} " : ''

    return prefix + many if (number % 100).between?(11, 14)

    word = case number % 10
      when 1 then one
      when 2..4 then few
      else
        many
    end

    prefix + word
  end
end
