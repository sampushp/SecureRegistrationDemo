Rails.application.routes.draw do
  root to: 'users#user_show'
  devise_for :users
  resources :users
  resources :secret_codes
end
