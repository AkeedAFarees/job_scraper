Rails.application.routes.draw do
  resources :skills
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'sessions#create'

  resources :users, :records

  get '/login', to: 'sessions#login'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'

  get '/scraper', to: 'scraper#index'

  get '/export', to: 'records#export'

end
