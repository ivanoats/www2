Given /I am on the new server page/ do
  visit "/servers/new"
end

Given /^the following servers:$/ do |servers|
  Server.create!(servers.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) server$/ do |pos|
  visit servers_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following servers:$/ do |servers|
  servers.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.should == cell
      }
    end
  end
end
