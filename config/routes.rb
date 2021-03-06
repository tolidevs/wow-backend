Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create, :show, :update, :destroy]
  resources :saved_shows, only: [:create, :destroy]
  resources :subscriptions, only: [:create, :destroy]
  resources :services, only: [:index]
  # resources :cached_shows

  post '/login', to: 'auth#create'
  get '/profile', to: 'users#profile'
  post '/signup', to: 'users#create'
  post '/user/saved_shows', to: 'users#get_saved_shows'
  post '/user/subscriptions', to: 'users#get_subscriptions'

  post '/search', to: 'application#search_shows'
  post '/show', to: 'application#get_show_details'
  post '/get_services', to: 'application#get_saved_services'

end
