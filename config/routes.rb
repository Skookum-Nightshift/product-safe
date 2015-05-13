Rails.application.routes.draw do
  devise_for :users
  resources :items

  resources :collections

<<<<<<< HEAD
  get 'search/item_search', to: 'search#item_search'
=======
  namespace :api do
    scope :pages do
      get '/home', to: 'pages#home'
    end
>>>>>>> 13e8e86490d02baaab77df645b95ba4f231c8c4a

    scope :search do
      get '/', to: 'search#find_all_where'
    end

    scope :products do
      post '/add', to: 'products#add'
    end
  end

  get '/search', to: 'pages#index'

  get '*any', to: 'pages#not_found'
  root 'pages#index'
end
