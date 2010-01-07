module ApplicationHelper
  
  # Sets the page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end
  
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div,(flash[msg.to_sym].blank? ? '' : content_tag(:p, flash[msg.to_sym], :id => msg)), :class => msg, :id => msg)
    end
    content_tag(:div, messages, :id => 'flash_messages')
  end
  
  include TagsHelper  #from acts_as_taggable on steroids
  
  def page_title 
    title = @page_title ? "| #{@page_title}" : '' 
    %(<title>Sustainable Websites Green Web Hosting #{title}</title>) 
  end 
  
  def meta(name, content) 
    %(<meta name="#{name}" content="#{content}" />) 
  end
 
  def meta_description 
    if @article and !@article.new_record? 
      "Information about #{@article.title}" 
    else 
      "Sustainable Websites Green Web Hosting" 
    end 
  end
  
  def meta_keywords 
    if @article and !@article.new_record? and !@article.user.nil?
      [@article.title, 
       @article.user.name, 
       @article.tag_list].join(',') 
    else 
      %w(green web site hosting sustainable website design coaching).join(',') 
    end 
  end
  
  # from http://wiki.rubyonrails.org/rails/pages/HowToUseTinyMCE
  def use_tinymce
    # Avoid multiple inclusions
    @content_for_tinymce = "" 
    content_for :tinymce do
      javascript_include_tag('tiny_mce/tiny_mce') + javascript_include_tag('mce_editor')
    end
  end
  
  def page_permalink_path(permalink = @page.permalink)
    "/#{permalink}"
  end
  
  def page_permalink_url(permalink = page_permalink_path)
    url_for(permalink)
  end
  
  def menu_link(title,url)
    url = 'http://www.sustainablewebsites.com' + url if RAILS_ENV == "production"
    link_to(title,url)
  end
  
  def current_account
    current_user ? Account.find_by_id(session[:account]) || current_user.accounts.first : nil
  end
end
