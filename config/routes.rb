Rails.application.routes.draw do
  namespace :admin do
    get "users/new"
    get "users/edit"
    get "users/show"
    get "users/index"
  end
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  root to: "tasks#index"
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
