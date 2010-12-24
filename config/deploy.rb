set :application, "project_zero"

role :app, "mieze.panter.local"
role :web, "mieze.panter.local"
role :db,  "mieze.panter.local"
set :rails_env, 'production'

set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :scm, :git
set :default_run_options, { :pty => true }
set :repository, "git@github.com:panter/railsmplayer.git"
set :ssh_options, {:forward_agent => true}
set :deploy_to, "/home/rails/app"
set :user, "rails"
set :use_sudo, false

task :update_config_links, :roles => [:app] do
  run "ln -sf #{shared_path}/config/* #{release_path}/config/"
end
after "deploy:update_code", :update_config_links

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy", "deploy:cleanup"
