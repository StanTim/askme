Rails.application.routes.draw do
  root 'users#index'

  # Ресурс пользователей
  resources :users, except: [:destroy]

  # Ресурс сессий (только три экшена :new, :create, :destroy)
  resource :session, only: [:new, :create, :destroy]

  # Ресурс вопросов
  resources :questions, except: [:show, :new, :index]

  # Ресурс хештеги. Стандартный адрес по соглашению для запросов :id заменен
  # на :text. - добавлено , param: :text, если не добавлять, то по-умолчанию будет :id
  resources :hashtags, only: :show, param: :text
end

