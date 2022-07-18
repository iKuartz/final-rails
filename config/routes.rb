Rails.application.routes.draw do
  namespace :v1, defaults: { format: 'json' } do
    resources :login, only:[:index] do
    end
    post '/register', to: 'login#create'    
  end
end
