Rails.application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  mount RuCaptcha::Engine => '/rucaptcha'

  namespace :admin do
    get :login, to: 'sessions#new'
    resources :articles
    resources :nodes
  end
end
