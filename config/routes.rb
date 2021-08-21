Rails.application.routes.draw do
  namespace :api do
    resource :trips, only: :create
    get 'stats/weekly'
    get 'stats/monthly'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
