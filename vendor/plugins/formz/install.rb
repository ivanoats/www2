require 'fileutils'

RAILS_ROOT = File.join(File.dirname(__FILE__), '../../../')

#####################################
# Copy resource files
#####################################

unless FileTest.exist? File.join(RAILS_ROOT, 'public', 'images', 'uni-form')
  FileUtils.mkdir( File.join(RAILS_ROOT, 'public', 'images', 'uni-form') )
end

FileUtils.cp(
  Dir[File.join(File.dirname(__FILE__), 'resources', 'public', 'javascripts', 'uni-form.prototype.js')],
  File.join(RAILS_ROOT, 'public', 'javascripts'),
  :verbose => true
)

FileUtils.cp( 
  Dir[File.join(File.dirname(__FILE__), 'resources', 'public', 'images', 'uni-form', '*.png')], 
  File.join(RAILS_ROOT, 'public', 'images', 'uni-form'),
  :verbose => true
)

FileUtils.rm_rf(File.join(RAILS_ROOT, 'public', 'stylesheets', 'uni-form-generic.css'),
  :verbose => true
)

FileUtils.cp( 
  File.join(File.dirname(__FILE__), 'resources', 'public', 'stylesheets', 'uni-form.css'), 
  File.join(RAILS_ROOT, 'public', 'stylesheets'),
  :verbose => true
)


#####################################
# Show the README text file
#####################################
puts IO.read(File.join(File.dirname(__FILE__), 'README'))

