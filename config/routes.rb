Rails.application.routes.draw do
  devise_for :users
  resources :posts
  get "u/:id", to: "users#show", as: :profile

  root "posts#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
