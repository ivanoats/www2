require 'rake'

namespace :db do
  desc "Dump the current database to a MySQL file" 
  task :database_dump do
    load 'config/environment.rb'
    abcs = ActiveRecord::Base.configurations
    case abcs[RAILS_ENV]["adapter"]
    when 'mysql'
      ActiveRecord::Base.establish_connection(abcs[RAILS_ENV])
      File.open("db/#{RAILS_ENV}_data.sql", "w+") do |f|
        if abcs[RAILS_ENV]["password"].blank?
          f << `mysqldump -h localhost -u #{abcs[RAILS_ENV]["username"]} #{abcs[RAILS_ENV]["database"]}`
        else
          f << `mysqldump -h localhost -u #{abcs[RAILS_ENV]["username"]} -p#{abcs[RAILS_ENV]["password"]} #{abcs[RAILS_ENV]["database"]}`
        end
      end
    when 'sqlite3'
      ActiveRecord::Base.establish_connection(abcs[RAILS_ENV])
      File.open("db/#{RAILS_ENV}_data.sql", "w+") do |f|
        f << `sqlite3  #{abcs[RAILS_ENV]["database"]} .dump`
      end
    else
      raise "Task not supported by '#{abcs[RAILS_ENV]['adapter']}'" 
    end
  end

  desc "Dump the billing database to a MySQL file and compress it" #only works on MySQL dbs
  task :whmap_dump do
    load 'config/environment.rb'
    abcs = ActiveRecord::Base.configurations
    ActiveRecord::Base.establish_connection(abcs['whmap'])
    File.open("db/whmap_data.sql", "w+") do |f|
      if abcs['whmap']["password"].blank?
        f << `mysqldump -h localhost -u #{abcs['whmap']["username"]} #{abcs['whmap']["database"]}`
      else
        f << `mysqldump -h localhost -u #{abcs['whmap']["username"]} -p#{abcs['whmap']["password"]} #{abcs['whmap']["database"]}`
      end #if
    end # file open
    tar_result = `tar -cvzf db/whmap_data.sql.tgz db/whmap_data.sql`
    puts "error code was:" + $?.to_i unless $?.to_i == 0   # display any error codes
    puts tar_result
  # then compress the file
  end # task

end
