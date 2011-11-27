Given /^I sign in with "([^"]*)" and "([^"]*)"$/ do |username, password|
  And %Q{I go to the new user session page}
  And %Q{I fill in "Email" with "#{username}"}
  And %Q{I fill in "Password" with "#{password}"}
  And %Q{I press "sign_in_submit_btn"}
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
    And %Q{I press "sign_in_submit_btn"}
  end
end


Given /^settings are seeded$/ do
  Settings.destroy_all
  Settings.seed!
end

Given /^signups are not disabled$/ do
  Settings.destroy_all
  setting = Settings.find_by_name('"sign-up-disabled')
  setting.update_attribute :value => 'no'
end

When /^there are no pages yet$/ do
  Page.destroy_all
end

Given /^jobs are being dispatched$/ do
    Delayed::Worker.new.work_off
end

#Given /^the following Kudo Categories exists:$/ do |table|
#  table.hashes.each do |attributes|
#    Factory :kudo_category, attributes
#  end
#end

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

Given /^the following Gifting Groups exist:$/ do |table|
  table.hashes.each do |attributes|
    Factory :gift_group, attributes
  end
end

#Given /^the following gifts exist:$/ do |table|
#  table.hashes.each do |attributes|
#    Factory :gift, attributes
#  end
#end

Given /^the a set of Gifts and Groups exist:$/ do
  group1 = Factory(:gift_group, :name => "group1")
  group2 = Factory(:gift_group, :name => "group2")
  Factory(:gift,  :name => "group_gift", 
                  :description => "testdescription",
                  :gift_group_ids => [group1.id])
  3.times do |i|
    Factory(:gift, :name => "gift#{i + 1}")
  end
end

Given /^the following identities exists without validation:$/ do |table|
  table.hashes.each do |attributes|
    identity = Identity.new(:user_id => attributes[:user_id],
                            :identity => attributes[:identity],
                            :identity_type => attributes[:identity_type])
    identity.save(:validate => false)
  end
end

When /^I loose focus from the "([^"]*)" field$/ do |field|
  page.execute_script %Q{$('#{field}').blur()}
end

When /^I attach the file at "(.*)" to "(.*)"$/ do |path, field|
  attach_file(field, path)
end

Given /^user "([^"]*)" has a flagged kudo$/ do |user_id|
  user = User.find(user_id.to_i)
  kudo = Factory(:kudo, :author => user)
  Factory(:kudo_flag, :id => user_id, :flagged_kudo => kudo)
end

Before('@background-jobs') do
  system "/usr/bin/env RAILS_ENV=#{Rails.env} rake jobs:work &"
end

After('@background-jobs') do
  system "ps -ef | grep 'rake jobs:work' | grep -v grep | awk '{print $2}' | xargs kill -9"
end
