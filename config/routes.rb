Rails.application.routes.draw do
  devise_for :users
  resources :items

  resources :collections

  namespace :api do
    scope :pages do
      get '/home', to: 'pages#home'
    end

    scope :search do
      get '/', to: 'search#find_all_where'
    end
  end

  get '*any', to: 'pages#not_found'
  root 'pages#index'
end
