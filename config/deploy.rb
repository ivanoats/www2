require 'yaml'

#############################################################
#	Application
#############################################################

set :application, "www2"

set :user, "deploy"
set :domain, "www2.sustainablewebsites.com"

server domain, :app, :web
role :db, domain, :primary => true
set :runner, user
set :keep_releases, 5

default_run_options[:pty] = true

#############################################################
#	Staging Support
#############################################################

set :stages, %w(staging production)
#set :default_stage, "staging"
require File.expand_path("#{File.dirname(__FILE__)}/../vendor/gems/capistrano-ext-1.2.1/lib/capistrano/ext/multistage")


#############################################################
#	Tasks
#############################################################

after :deploy, "passenger:restart"
after "deploy:update_code","deploy:symlink_configs"


# desc "Backup the database before running migrations"
# task :before_migrate do 
#   backup
# end

#############################################################
#	Repository
#############################################################

set :scm, "git"
set :repository, "ssh://git@sw.unfuddle.com/sw/www2.git"

set :branch, "master"
set :deploy_via, :remote_cache
set :ssh_options, {  :port => 28822 }

set :git_enable_submodules, 1

#############################################################
#	Passenger
#############################################################

namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

#############################################################
#	Shared
#############################################################

namespace(:deploy) do
 task :symlink_configs, :roles => :app, :except => {:no_symlink => true} do
   run <<-CMD
     cd #{release_path} &&
     ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml
   CMD
 end
 
 task :after_symlink do
       run "ln -nfs #{shared_dir}/assets/images #{release_dir}/public/images"
       run "ln -nfs #{shared_dir}/assets/videos #{release_dir}/public/videos"
       run "ln -nfs #{shared_dir}/assets/tutorial_cpanel #{release_dir}/public/tutorial_cpanel"
       run "ln -nfs #{shared_dir}/assets/tutorial_email #{release_dir}/public/tutorial_email"  
       run "ln -nfs #{shared_dir}/assets/tutorial_wordpress #{release_dir}/public/tutorial_wordpress"
       run "ln -nfs #{shared_dir}/assets/FlashHelp #{release_dir}/public/FlashHelp"    
   end
  

 desc "restart override"
 task :restart, :roles => :app do
 end
end

#############################################################
#	Database Tasks
#############################################################

namespace :db do
  desc 'Dumps the production database to db/production_data.sql on the remote server'
  task :remote_db_dump, :roles => :db, :only => { :primary => true } do
    run "cd #{deploy_to}/#{current_dir} && " +
      "rake RAILS_ENV=production db:database_dump --trace" 
  end

  desc 'Downloads db/production_data.sql from the remote production environment to your local machine'
  task :remote_db_download, :roles => :db, :only => { :primary => true } do  
    execute_on_servers(options) do |servers|
      self.sessions[servers.first].sftp.connect do |tsftp|
        tsftp.download!("#{deploy_to}/#{current_dir}/db/production_data.sql", "db/production_data.sql")
      end
    end
  end

  desc 'Cleans up data dump file'
  task :remote_db_cleanup, :roles => :db, :only => { :primary => true } do
    execute_on_servers(options) do |servers|
      self.sessions[servers.first].sftp.connect do |tsftp|
        tsftp.remove! "#{deploy_to}/#{current_dir}/db/production_data.sql" 
      end
    end
  end 

  desc 'Dumps, downloads and then cleans up the production data dump'
  task :remote_db_runner do
    remote_db_dump
    remote_db_download
    remote_db_cleanup
  end

  
end

