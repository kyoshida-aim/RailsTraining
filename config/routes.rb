Rails.application.routes.draw do
  get "user/new"
  post "user/new", to: "user#create"
  get "user/edit"
  namespace :admin do
    resources :users
  end
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  root to: "tasks#index"
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
