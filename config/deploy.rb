# require "capistrano-resque"

# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'msj'
set :deploy_to, "~/www/#{fetch(:application)}/"
set :repo_url, 'git@github.com:jimhj/one_cms.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :delayed_job_workers, 8

# Default deploy_to directory is /var/www/my_app_name
set :delayed_log_dir, "#{shared_path}/log"

set :unicorn_config_path, "#{current_path}/config/unicorn.rb"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/config.yml', 'config/seed_data.yml', 'config/unicorn.rb')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'public/page_cache')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :rvm1_ruby_version, '2.1.0'

set :rails_env, :production

# set :rvm_type, :user

# Default value for keep_releases is 5
set :keep_releases, 10

set :pid_path, "#{shared_path}/tmp/pids"
set :log_path, "#{shared_path}/log"

namespace :deploy do
  task :restart do
    invoke 'unicorn:legacy_restart'
    invoke 'delayed_job:restart'
  end
end

namespace :whenever do
  task :refresh do
    on roles(:web, :db, :app) do
      within release_path do
        execute :bundle, "exec whenever -c -s 'environment=production'"
        execute :bundle, "exec whenever -w -s 'environment=production'"
      end
    end
  end
end

namespace :sitemap do
  task :refresh do
    on roles(:web, :db, :app) do
      within release_path do
        with rails_env: :production do
          execute :bundle, "exec rake g:sitemap --trace"
        end
      end
    end    
  end
end

namespace :clear do
  task :cache do
    on roles(:web, :db, :app) do
      within release_path do
        with rails_env: :production do
          execute :bundle, "exec rake tmp:clear --trace"
        end
      end
    end    
  end
end

after 'deploy:published', 'deploy:restart'
after 'deploy:published', 'whenever:refresh'
# after 'deploy:restart', 'sitemap:refresh'


