set :deploy_to, "/var/www/#{application}_staging"
set :rails_env, "staging"
set :production_deploy_to, "/var/www/#{application}"

namespace :copy do
  desc "Clone Production Environment to Staging"
  task :production do
    run "cp -R #{production_deploy_to}/shared/assets/* #{deploy_to}/shared/assets/"
    
    filename = "www2_sw_staging.sql"
    file = "/var/backups/#{application}/#{filename}"
    run "mysqldump -u root www2_sw_production > #{file}"
    run "mysql -u root www2_sw_staging < #{file}"
    
  end
end
