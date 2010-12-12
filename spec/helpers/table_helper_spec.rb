require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ApplicationHelper
include TableHelper

describe TableHelper do
  
  it 'should model_table an empty table with no records' do
    model_table([])
    output_buffer.should == "<table class=\"model_table\"><tbody><tr></tr></tbody></table>"
  end
  
  it 'should model_table with records' do
    model_table([User.make,User.make])
    output_buffer.should == "<table class=\"model_table\"><tbody><tr><tr class=\"odd\"></tr><tr class=\"even\"></tr></tr></tbody></table>"
  end

  it 'should model_table with an empty block' do
    model_table([User.make,User.make]) do |record|
    end
    output_buffer.should have_tag('table.model_table')
    output_buffer.should == "<table class=\"model_table\"><tbody><tr><tr class=\"odd\"></tr><tr class=\"even\"></tr></tr></tbody></table>"
  end

  it 'should model_table with a block' do
    @users = [User.make,User.make]
    model_table(@users) do |record|
      "<td>#{record.name}</td>"
    end
    output_buffer.should have_tag('table.model_table')
    output_buffer.should include_text(@users.first.name)    
  end
  
  it 'should model_table with fields' do
    @users = [User.make,User.make]
    model_table(@users, :fields => [:name])
    output_buffer.should == "<table class=\"model_table\"><tbody><tr><th>Name</th><tr class=\"odd\"></tr><tr class=\"even\"></tr></tr></tbody></table>"
  end
  
  

  
end
