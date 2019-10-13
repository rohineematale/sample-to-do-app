Rails.application.routes.draw do
  root to: "tasks#index"
  devise_for :users
  resources :tasks, except: :show do
    member do
      patch :update_task, to: 'tasks#update_task'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
