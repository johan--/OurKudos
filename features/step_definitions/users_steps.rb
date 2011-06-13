Before('@omniauth_test_failure') do
  OmniAuth.config.test_mode = true

  [:facebook, :twitter].each do |service|
    OmniAuth.config.mock_auth[service] = :invalid_credentials
  end
end

Before('@omniauth_test_success_facebook') do
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:facebook] = {
    "provider"  => "facebook",
    "uid"       => '12345',
    "user_info" => {
      "email" => "marcin.walczak@gmail.com",
      "first_name" => "Marcin",
      "last_name"  => "Walczak",
      "name"       => "Marcin Walczak"
    },
    'credentials'=> {
      'token' => 'facebook token'
    }
  }
end

Before('@omniauth_test_success_twitter') do
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:twitter] = {
    "provider"  => "twitter",
    "uid"       => '123456',
    "user_info" => {
      "email" => "marcin.walczak@gmail.com",
      "first_name" => "Marcin",
      "last_name"  => "Walczak",
      "name"       => "Marcin Walczak"
    },
    'credentials'=> {
      'token' => 'twitter token',
      'secret' => 'twitter secret'
    }
  }
end


Given /^there are no users yet$/ do
  User.destroy_all
end

Then /^I should have "([^"]*)"\-length api key generated$/ do |length|
  !User.first.api_key.blank? && User.first.api_key.size == length.to_i
end


Given /^I don't have any authentications yet$/ do
 Authentication.destroy_all
end

