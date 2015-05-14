Rails.application.routes.draw do
  devise_for :users
  resources :items

  resources :collections


  namespace :api do
    scope :pages do
      get '/home', to: 'pages#home'
      get '/add', to: 'pages#add'
    end

    scope :search do
      get '/', to: 'search#find_all_where'
      get '/users/items', to: 'search#find_users_item'
    end

    scope :products do
      post '/add', to: 'products#add'
    end
  end

  get '/search', to: 'pages#index'
  get '/add', to: 'pages#add'

  get '*any', to: 'pages#not_found'
  root 'pages#index'
end
