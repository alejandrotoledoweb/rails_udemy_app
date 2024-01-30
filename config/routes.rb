Rails.application.routes.draw do
  devise_for :users
  resources :courses do
    resources :lessons
  end
  resources :users, only: %i[index destroy edit show update]
  get "/users/:id/delete_confirmation",
      to: "users#delete_confirmation",
      as: "user_delete_confirmation"

  get "static_pages/landing_page"
  get "static_pages/privacy_policy"
  post "users/:id/send_email", to: "users#send_email", as: "send_user_email"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  root "static_pages#homepage"
end
