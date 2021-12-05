Rails.application.routes.draw do
  root 'users#index'

  # Ресурс пользователей
  resources :users

  # Ресурс сессий (только три экшена :new, :create, :destroy)
  resource :sessions, only: [:new, :create, :destroy]

  # Ресурс вопросов
  resources :questions

  # Синонимы путей — в дополнение к созднным в ресурсах выше.
  #
  # Для любознательных: синонимы мы добавили, чтобы показать одну вещь и потом
  # их удалим.
  get 'sign_up' => 'users#new'
  get 'log_out' => 'sessions#destroy'
  get 'log_in' => 'sessions#new'
end
