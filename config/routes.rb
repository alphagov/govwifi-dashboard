Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'watchdog/widgets#index'

  mount Watchdog::Engine, at: '/watchdog'
end
