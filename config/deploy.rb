require 'yaml'

#############################################################
#	Application
#############################################################

set :application, "www2"

set :deploy_to, "/var/www/#{application}"
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

# set :stages, %w(staging production)
# set :default_stage, "production"
# require File.expand_path("#{File.dirname(__FILE__)}/../vendor/gems/capistrano-ext-1.2.1/lib/capistrano/ext/multistage")


#############################################################
#	Tasks
#############################################################

before :deploy, "db:backup"
after :deploy, "passenger:restart"
after "deploy:update_code","deploy:symlink_configs"


# desc "Backup the database before running migrations"
# task :before_migrate do 
#   backup
# end

#############################################################
#	Repository
#############################################################

#set :repository,  "git@sw.unfuddle.com:sw/www2.git"
set :scm, "git"
set :repository, "ssh://git@sw.unfuddle.com/sw/www2.git"
#set :git_shallow_clone, 1

set :branch, "master"
set :deploy_via, :remote_cache
set :ssh_options, {  :port => 28822 }

set :git_enable_submodules, 1

#I finally got this working using a key on www2, lets just stick with that.
#ssh_options[:forward_agent] = true

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
  
  desc "Backup the remote production database"
  task :backup, :roles => :db, :only => {:primary => true} do
    filename = "#{application}.dump.#{Time.now.to_i}.sql.bz2"
    file = "/var/backups/#{application}/#{filename}"
    on_rollback { delete file }
    #db = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), 'database.yml'))).result)['production']
    #run "mysqldump -u #{db['username']} --password=#{db['password']} #{db['database']} | bzip2 -c > #{file}"  do |ch, stream, data|
    run "mysqldump -u root www2_sw_production | bzip2 -c > #{file}"  do |ch, stream, data|
      puts data
    end
  end
  
end

