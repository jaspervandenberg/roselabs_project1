Rails.application.routes.draw do
  root 'test#index'

  namespace :api, constraints: { format: 'text' } do
    namespace :v1 do
      resource :devices
    end
  end
end
