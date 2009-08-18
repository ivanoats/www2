set :deploy_to, "/var/www/#{application}"
set :rails_env, "production"

before :deploy, "db:backup"

namespace :db do  
  desc "Backup the remote production database"
  task :backup, :roles => :db, :only => {:primary => true} do
    filename = "#{application}.dump.#{Time.now.to_i}.sql.bz2"
    file = "/var/backups/#{application}/#{filename}"
    on_rollback { delete file }
    run "mysqldump -u root www2_sw_production | bzip2 -c > #{file}"  do |ch, stream, data|
      puts data
    end
  end
end