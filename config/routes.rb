class MobileConstraint
  def self.matches?(request)
    (request.user_agent.to_s =~ /Mobile|webOS/) or request.subdomain.start_with?('m.')
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
    resources :nodes do
      collection do
        get :list
      end
    end

    resources :keywords
    resources :links, except: :show
    resources :channels
    resources :site_ads
    get 'site_config',  to: 'site_config#edit',     as: :site_config
    post 'site_config', to: 'site_config#update',  as: :site_configs
    scope :cache, controller: 'cache', as: :cache do
      get '/', to: 'cache#index'
      post 'refresh', to: 'cache#refresh', as: :refresh
      post :refresh_all
      post :precompile
      post :restart
    end
  end

  match 'sitemap/:node_id-:page', to: 'sitemap#show', constraints: { format: 'xml' }, via: :get

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
    get 'more',         to: 'application#more'
    resources :tags,  only: [:index, :show],    trailing_slash: true    
    get 'feed',         to: 'articles#feed',    as: :feed
    get 'search',       to: 'articles#search',  as: :search
    get 'z',            to: 'channels#index',   as: :channels, trailing_slash: true
    get 'z/:slug',      to: 'channels#show',    as: :channel, trailing_slash: true
    get ':slug/:id',    to: 'articles#show',    as: :article
    get ':slug',        to: 'articles#index',   as: :articles, trailing_slash: true
  end
end
