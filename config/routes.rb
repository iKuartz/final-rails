Rails.application.routes.draw do
  namespace :v1, defaults: { format: 'json' } do
    resources :login, only:[:index]
    post '/register', to: 'login#create'
    resources :hotels, only: [:index]
  end
end
