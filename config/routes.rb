Rails.application.routes.draw do
  resource :users, only: [:create]

  post '/login', to: 'users#login'

  post '/accounts', to: 'accounts#create'
  patch '/accounts/:id', to: 'accounts#update'
end
