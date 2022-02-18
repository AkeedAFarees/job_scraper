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

  post 'password/forgot', to: 'password#forgot'
  post 'password/reset', to: 'password#reset'

  put 'password/update', to: 'password#update'
  get 'password/edit', to: 'password#edit'


end
