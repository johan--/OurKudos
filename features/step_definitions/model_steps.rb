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


Given /^settings are seeded$/ do
  Settings.seed!
end

Given /^jobs are being dispatched$/ do
    Delayed::Worker.new.work_off
end

Given /^the following Kudo Categories exists:$/ do |table|
  table.hashes.each do |attributes|
    Factory :kudo_category, attributes
  end
end

Given /^the following Affiliate Programs exists:$/ do |table|
  table.hashes.each do |attributes|
    Factory :affiliate_programs, attributes
  end
end

Given /^the following Merchants exists:$/ do |table|
  table.hashes.each do |attributes|
    Factory :merchants, attributes
  end
end

Given /^the following Gift Groups exist:$/ do |table|
  table.hashes.each do |attributes|
    Factory :gift_group, attributes
  end
end

Given /^the following Gifts exist:$/ do |table|
  table.hashes.each do |attributes|
    Factory :gift, attributes
  end
end

Before('@background-jobs') do
  system "/usr/bin/env RAILS_ENV=#{Rails.env} rake jobs:work &"
end

After('@background-jobs') do
  system "ps -ef | grep 'rake jobs:work' | grep -v grep | awk '{print $2}' | xargs kill -9"
end
