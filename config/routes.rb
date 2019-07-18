Rails.application.routes.draw do
  namespace :admin do
    resources :users
    get "user/:user_id/tasks", to: "tasks#index", as: "user_tasks"
    get "user/:user_id/tasks/:task_id", to: "tasks#show", as: "user_task"
  end
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  root to: "tasks#index"
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
