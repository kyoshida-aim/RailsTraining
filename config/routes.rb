Rails.application.routes.draw do
  resources :users, only: [:create, :new, :edit, :update]
  namespace :admin do
    resources :users do
      resources :tasks, only: [:index, :show]
    end
  end
  resources :labels
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  root to: "tasks#index"
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
