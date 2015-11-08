Rails.application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  mount RuCaptcha::Engine => '/rucaptcha'

  namespace :onecmsmanage, module: :admin, as: :admin do
    get :login, to: 'sessions#new'
    post :login, to: 'sessions#create'
    resources :articles
    resources :nodes
    resources :keywords
  end
end
