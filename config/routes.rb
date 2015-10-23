Rails.application.routes.draw do
  namespace :admin do
    get :login, to: 'sessions#new'
    resources :articles
  end
end
