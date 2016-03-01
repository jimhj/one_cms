class MobileConstraint
  def self.matches?(request)
    (request.user_agent.to_s =~ /Mobile|webOS/) or request.subdomain == 'm.h4'
  end
end

Rails.application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  mount RuCaptcha::Engine => '/rucaptcha'

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  namespace :onecmsmanage, module: :admin, as: :admin do
    get :login, to: 'sessions#new'
    post :login, to: 'sessions#create'
    resources :articles
    resources :nodes
    resources :keywords
    resources :links, except: :show
    resources :channels
    resources :site_ads
    get 'site_config',  to: 'site_config#edit',     as: :site_config
    post 'site_config', to: 'site_config#update',  as: :site_configs
  end

  constraints(MobileConstraint) do
    scope module: 'mobile', as: :mobile do
      root 'application#index'
      resources :tags,  only: [:index, :show],    trailing_slash: true
      get 'z',            to: 'channels#index',   as: :channels, trailing_slash: true
      get 'z/:slug',      to: 'channels#show',    as: :channel, trailing_slash: true
      get ':slug/:id',    to: 'articles#show'
      get ':slug',        to: 'articles#index',   as: :articles, trailing_slash: true
    end
  end 
  
  scope module: :site do
    root 'application#index'
    resources :tags,  only: [:index, :show],    trailing_slash: true    
    get 'feed',         to: 'articles#feed',    as: :feed
    get 'search',       to: 'articles#search',  as: :search
    get 'z',            to: 'channels#index',   as: :channels, trailing_slash: true
    get 'z/:slug',      to: 'channels#show',    as: :channel, trailing_slash: true
    get ':slug/:id',    to: 'articles#show',    as: :article
    get ':slug',        to: 'articles#index',   as: :articles, trailing_slash: true
  end 
end
