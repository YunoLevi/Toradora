Rails.application.routes.draw do
  resources :categories

  get '/auth/:provider/callback', to: 'sessions#create'
  get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'categories/tweets/index', to: 'tweets#index'
  resources :tweets
  resources :categories
  root to: "tweets#index"
end
