Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:create]
  resource :session, only: [:create, :destroy]
  resources :quotes, controller: 'properties', only: [:index, :show, :create, :update, :destroy]
  post 'quotes/bulk', to: 'properties#bulk_create'
end
