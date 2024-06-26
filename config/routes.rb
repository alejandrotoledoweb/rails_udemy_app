Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
    member do
      get :certification
    end
  end
  # devise_for :users
  devise_for :users, controllers: {
        registrations: 'users/registrations',
        sessions: 'users/sessions',
        omniauth_callbacks: 'users/omniauth_callbacks'
      }
  resources :courses do
    member do
      patch :approve
      patch :unapprove
    end
    get :purchased, :created, :unapproved, on: :collection
    resources :lessons
    resources :enrollments, only: %i[new create]
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
