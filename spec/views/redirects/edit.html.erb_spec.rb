require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/redirects/edit.html.erb" do
  include RedirectsHelper
  
  before(:each) do
    assigns[:redirect] = @redirect = stub_model(Redirect,
      :new_record? => false,
      :slug => "value for slug",
      :url => "value for url",
      :notes => "value for notes"
    )
  end

  it "should render edit form" do
    render "/redirects/edit.html.erb"
    
    response.should have_tag("form[action=#{redirect_path(@redirect)}][method=post]") do
      with_tag('input#redirect_slug[name=?]', "redirect[slug]")
      with_tag('input#redirect_url[name=?]', "redirect[url]")
      with_tag('textarea#redirect_notes[name=?]', "redirect[notes]")
    end
  end
end


