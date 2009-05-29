require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/redirects/new.html.erb" do
  
  
  before(:each) do
    assigns[:redirect] = stub_model(Redirect,
      :new_record? => true,
      :slug => "value for slug",
      :url => "value for url",
      :notes => "value for notes"
    )
  end

  it "should render new form" do
    render "/redirects/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", redirects_path) do
      with_tag("input#redirect_slug[name=?]", "redirect[slug]")
      with_tag("input#redirect_url[name=?]", "redirect[url]")
      with_tag("textarea#redirect_notes[name=?]", "redirect[notes]")
    end
  end
end


