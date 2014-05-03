require "bundler/capistrano"
require 'capistrano-unicorn'

load 'deploy/assets'

set :default_environment, {
  'RBENV_ROOT' => '/usr/local/rbenv',
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

set :application, "54.214.2.25"
set :user, "stackbox"
set :use_sudo, false

set :repository,  "git://github.com/ircloud/website.git"
#set :branch, "deploy"

set :ssh_options, { :forward_agent => true }
set :deploy_to, "/home/stackbox/www/"

set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "Apache"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

server "54.214.2.25", :app, :web, :db, :primary => true

after 'deploy:update_code', 'deploy:migrate'
#after 'deploy:migrate', :defaultsettings
# if you want to clean up old releases on each deploy uncomment this:
#set :keep_releases, 5
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  namespace :assets do
    desc 'Run the precompile task locally and rsync with shared'
    task :precompile, :roles => :web, :except => { :no_release => true } do
      %x{bundle exec rake assets:precompile}
      %x{rsync --recursive --times --rsh=ssh --compress --human-readable --progress public/assets #{user}@#{web}:#{shared_path}}
      %x{bundle exec rake assets:clean}
    end
  end

end
after "deploy:update_code", :precompile_assets
desc "precompile the assets"
task :precompile_assets, :roles => :app do
  run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
end


after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'   # app preloaded
after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)
