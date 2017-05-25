# require "capistrano-resque"

# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'msj'

set :deploy_to, "~/www/#{fetch(:application)}/"
set :repo_url, 'git@github.com:jimhj/one_cms.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :delayed_job_workers, 4

# Default deploy_to directory is /var/www/my_app_name
set :delayed_log_dir, "#{shared_path}/log"

set :unicorn_config_path, "#{current_path}/config/unicorn.rb"
set :unicorn_restart_sleep_time, 5

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push(
  'config/database.yml', 
  'config/secrets.yml', 
  'config/config.yml', 
  'config/seed_data.yml', 
  'config/unicorn.rb', 
  'public/baidu_mip_record.txt'
)

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log', 
  'tmp/pids', 
  'tmp/cache', 
  'tmp/sockets', 
  'vendor/bundle', 
  'public/system',
  'public/uploads', 
  'public/cached_pages',
  'public/mobile_cached_pages'
)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :rvm1_ruby_version, '2.1.0'

set :rails_env, :production

set :rvm_type, :user
set :rvm_ruby_version, '2.3.0'

# Default value for keep_releases is 5
set :keep_releases, 5

set :whenever_identifier, -> { "#{fetch(:application)}" }
set :pid_path, "#{current_path}/tmp/pids"
set :log_path, "#{current_path}/log"
set :unicorn_pid, -> {"#{current_path}/tmp/pids/unicorn.pid"}

namespace :deploy do
  task :restart do
    invoke 'unicorn:legacy_restart'
    invoke 'delayed_job:restart'
    invoke 'whenever:update_crontab'
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
          execute :bundle, "exec rake g:mipmap --trace"
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

namespace :assets do
  task :precompile do
    on roles(:web, :db, :app) do
      within release_path do
        with rails_env: :production do
          execute :bundle, "exec rake assets:precompile --trace"
        end
      end
    end    
  end
end

namespace :baidu do
  task :mip do
    on roles(:web, :db, :app) do
      within release_path do
        with rails_env: :production do
          execute :bundle, "exec rake baidu:notify_mip --trace"
        end
      end
    end    
  end
end

after 'deploy:publishing', 'deploy:restart'
# after 'deploy:restart', 'sitemap:refresh'


