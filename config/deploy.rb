# config valid only for current version of Capistrano
lock "3.9.0"

set :application, "qna2017"
set :repo_url, "git@github.com:rustamakhmetov/qna2017.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna2017"
set :deploy_user, "deployer"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", ".env", "config/production.sphinx.conf"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      #execute :touch, release_path.join("tmp/restart.txt")
      invoke "unicorn:restart"
    end
    on fetch(:migration_servers) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'ts:rebuild'
        end
      end
    end
  end

  after :publishing, :restart
end
