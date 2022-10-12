Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get '/member-data', to: "members#show"

  # resources :sessions, only: [:create]
  resources :registrations, only: [:create]
  # delete :logout, to: "sessions#logout"
  # get :"logged_in", to: "sessions#logged_in"

  # get "strava_auth", to: "strava_auth#index" #todo to be removed
  # get 'two', to: "strava_auth#code_auth"     #todo to be removed
  # post 'strava_auth_controller', to: 'strava_auth#third_code', as: 'third_step'

end
