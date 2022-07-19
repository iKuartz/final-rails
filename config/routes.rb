Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :v1, defaults: { format: 'json' } do
    resources :login, only:[:index]
    post '/register', to: 'login#create'
    resources :hotels, only: [:index]
  end
end
