Rails.application.routes.draw do
  devise_for :users
  root 'pages#show'

  resource :page
  resources :blood_sugars
  resource :device
  resources :firmwares

  namespace :admin do
    resources :firmwares
    resources :devices
  end

  namespace :api, constraints: { format: 'text' } do
    namespace :v1 do
      resource :devices
      resources :firmwares, only: [:show, :index]
    end
  end
end
