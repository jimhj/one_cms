Rails.application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  mount RuCaptcha::Engine => '/rucaptcha'

  namespace :onecmsmanage, module: :admin, as: :admin do
    get :login, to: 'sessions#new'
    post :login, to: 'sessions#create'
    resources :articles
    resources :nodes
    resources :keywords
    resources :links, except: :show
    resources :channels
  end

  scope module: :site do
    root 'application#index'
    get 'feed',         to: 'articles#feed',    as: :feed
    resources :tags,  only: [:index, :show]
    get ':slug/:id',    to: 'articles#show'
    get ':slug',        to: 'articles#index',   as: :articles
  end
end
