Rails.application.routes.draw do
  root 'sessions#create'

  resources :users, :records, :skills

  get '/login', to: 'sessions#login'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/scraper', to: 'scraper#index'
  get '/export', to: 'records#export'

  post 'password/forgot', to: 'password#forgot'
  post 'password/reset', to: 'password#reset'

  put 'password/update', to: 'password#update'
  get 'password/edit', to: 'password#edit'

  get '/calculate_form', to: 'skills#calculate_form'
  post '/calculate', to: 'skills#calculate'

end
