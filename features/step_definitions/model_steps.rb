Given /^I sign in with "([^"]*)" and "([^"]*)"$/ do |username, password|
  And %Q{I go to the new user session page}
  And %Q{I fill in "Email" with "#{username}"}
  And %Q{I fill in "Password" with "#{password}"}
  And %Q{I press "Sign in"}
end

Given /^I'm logged in as an administrator with:$/ do |table|
  table.hashes.each do |attributes|
    Factory :admin_user, attributes
    And %Q{I sign in with "#{attributes[:email]}" and "#{attributes[:password]}"}
  end
end

Given /^I'm logged in as a user with:$/ do |table|
  table.hashes.each do |attributes|
    Factory :user, attributes
    And %Q{I sign in with "#{attributes[:email]}" and "#{attributes[:password]}"}
  end
end

Given /^I tried to login with "([^"]*)" email "([^"]*)" times unsuccessfully$/ do |email, times|  
  times.to_i.times do
    And %Q{I go to the new user session page}
    And %Q{I fill in "Email" with "#{email}"}
    And %Q{I fill in "Password" with "'badpass'"}
    And %Q{I press "Sign in"}
  end
end


