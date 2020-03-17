Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create, :show, :update, :delete]
  # resources :cached_shows

  post '/login', to: 'auth#create'
  get '/profile', to: 'users#profile'
  post '/signup', to: 'users#create'

  post '/search', to: 'application#search_shows'
  post '/show', to: 'application#get_show_details'

end
