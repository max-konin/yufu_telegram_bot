# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'yufu_telegram_bot'
set :repo_url, 'https://github.com/max-konin/yufu_telegram_bot.git'
ask :branch, 'master'
set :password, ask('Server password:', nil, echo: false)
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml')
# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'pids', 'tmp/cache', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  after :restart, :restart_telegram_bot do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        with rails_env: "#{fetch(:stage)}" do
          execute :rake, 'daemon:telegram_bot:restart'
        end
      end
    end
  end
end