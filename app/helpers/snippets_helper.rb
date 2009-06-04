module SnippetsHelper
  
  include ActionView::Helpers::AssetTagHelper
  
  def stylesheet_snippets
    snippets = Dir.chdir(File.join(STYLESHEETS_DIR, '/snippets/')) do Dir.glob('*.css') end
    snippets.collect! { |snippet| 'snippets/' + snippet}    
    stylesheet_link_tag(snippets , :cache => 'snippets')
  end
  
end