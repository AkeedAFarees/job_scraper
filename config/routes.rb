Rails.application.routes.draw do
  resources :settings
  root 'sessions#create'

  resources :users, :records, :skills

  get '/login', to: 'sessions#login'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/scraper', to: 'scraper#index'
  get '/export', to: 'records#export'

  get '/update_experience', to: 'skills#update_experience'
  get '/calculate_form', to: 'skills#calculate_form'
  post '/calculate', to: 'skills#calculate'
  get '/cancel_update/:id', to: 'skills#cancel_update', as: :cancel_update

  get '/edit_password', to: 'users#edit_password'
  post '/update_password', to: 'users#update_password'

end
