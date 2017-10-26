Rails.application.routes.draw do
  devise_for :users, skip: :registration
  root 'home#index'

  get 'home/index'
  get '/schedule', to: 'schedule#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
