Rails.application.routes.draw do
  root 'users#index'

  # Ресурс пользователей
  resources :users, except: [:destroy]

  # Ресурс сессий (только три экшена :new, :create, :destroy)
  resources :sessions, only: [:new, :create, :destroy]

  # Ресурс вопросов
  resources :questions, except: [:show, :new, :index]

  # Ресурс хештеги. Стандартный адрес по соглашению для запросов :id заменен
  # на :text. - добавлено , params: :text, если не добавлять, то по-умолчанию будет :id
  resources :hashtags, only: :show, params: :text

  # Синонимы путей — в дополнение к созднным в ресурсах выше.
  #
  # Для любознательных: синонимы мы добавили, чтобы показать одну вещь и потом
  # их удалим.
  get 'sign_up' => 'users#new'
  get 'log_out' => 'sessions#destroy'
  get 'log_in' => 'sessions#new'
end

