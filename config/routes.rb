class MobileConstraint
  def self.matches?(request)
    true
    # (request.user_agent.to_s =~ /Mobile|webOS/) or request.subdomain == 'm' or true
  end
end

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
    get 'site_config',  to: 'site_config#edit',     as: :site_config
    post 'site_config', to: 'site_config#update',  as: :site_configs
  end

  constraints(MobileConstraint) do
    scope module: 'mobile', as: :mobile do
      root 'application#index'
      resources :tags,  only: [:index, :show]
      get 'z',            to: 'channels#index',   as: :channels
      get 'z/:slug',      to: 'channels#show',    as: :channel
      get ':slug/:id',    to: 'articles#show'
      get ':slug',        to: 'articles#index',   as: :articles
    end
  end 
  
  scope module: :site do
    root 'application#index'
    get 'feed',         to: 'articles#feed',    as: :feed
    resources :tags,  only: [:index, :show]
    get 'z',            to: 'channels#index',   as: :channels
    get 'z/:slug',      to: 'channels#show',    as: :channel
    get ':slug/:id',    to: 'articles#show'
    get ':slug',        to: 'articles#index',   as: :articles
  end 
end
