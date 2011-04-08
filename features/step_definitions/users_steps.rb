Given /^there are no users yet$/ do
  User.destroy_all
end

Then /^I should have "([^"]*)"\-length api key generated$/ do |length|
  !User.first.api_key.blank? && User.first.api_key.size == length.to_i
end

