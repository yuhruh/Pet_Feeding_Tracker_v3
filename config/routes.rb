Rails.application.routes.draw do
  root "pages#home"
  scope "(:locale)", locale: /en|zh-TW/ do
    get '/signup', to: "registrations#new", as: :new_registrations
    post 'registration/create', to: "registrations#create", as: :registrations
    resource :session, except: [ :new ]
    get '/login', to: "sessions#new", as: :new_session
    get "/home", to: "pages#home"
    get "/about", to: "pages#about"
    get "/started", to: "pages#started"
    # User Profile
    resources :users, except: [:new]
    # get "users/edit", to: "users#edit", as: :edit_user_profile
    # patch "users/update_profile", to: "users#update_profile", as: :update_user_profile
    # get "users/manage_password", to: "users#manage_password", as: :manage_password
    # patch "users/update_password", to: "users#update_password", as: :update_password
    # get "users/remove_avatar", to: "users#remove_avatar", as: :remove_user_avatar
  end
  # since session controller only define new, create and destroy
  # resource :session, only: [:new, :create, :destroy] 
  # do not need to access the index, show or distroy actions for the password route.
  resources :passwords, only: [:new, :create, :edit, :update], param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
