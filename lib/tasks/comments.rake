namespace :comments do

  desc 'cleans spam from comments'
  task(:clean => :environment) do
    puts "Starting Comment cleaner at #{Time.now}"
    #loop through comments
    #check for badwords
    badwords = %w(viagra cialis isuzuforums.com phentermine ativan xanax valium tamiflu tramadol diazepam lorazepam zolpidem klonopin clonazepam)
    #delete if they have badwords
    comments = Comment.find(:all)
    comments.each do |c|
      badwords.each do |bw|    
        c.destroy() if c.comment.downcase.include?(bw)
      end
    end
    puts "Completed Comment cleaner at #{Time.now}"
  end
end