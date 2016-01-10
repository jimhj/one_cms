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

  scope module: :site do
    root 'application#index'
    get '*slug/:id', to: 'articles#show', id: /\d.+/
    get '*slug', to: 'articles#index'    
  end
end
