Rails.application.routes.draw do
  devise_for :users
  root 'firmwares#index'

  resources :firmwares
  resources :devices

  namespace :api, constraints: { format: 'text' } do
    namespace :v1 do
      resource :devices
      resources :firmwares, only: [:show, :index]
    end
  end
end
