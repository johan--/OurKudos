Before('@omniauth_test_failure') do
  OmniAuth.config.test_mode = true
  [:facebook, :twitter].each do |service|
    OmniAuth.config.mock_auth[service] = :invalid_credentials
    # or whatever status code you want to stub
  end
end


Given /^there are no users yet$/ do
  User.destroy_all
end

Then /^I should have "([^"]*)"\-length api key generated$/ do |length|
  !User.first.api_key.blank? && User.first.api_key.size == length.to_i
end

