Rails.application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  namespace :admin do
    get :login, to: 'sessions#new'
    resources :articles
  end
end
