Feature: Users regristration / management

Scenario: User can create an account natively
  Given there are no users yet
  When I go to the home page
  And I follow "SIGN UP"
  And I fill in "Email" with "marcin.walczak@gmail.com"
  And I fill in "First name" with "Marcin"
  And I fill in "Last name" with "Walczak"
  And I fill in "Password" with "verysecretpassword"
  And I fill in "Password confirmation" with "verysecretpassword"
  And I press "Sign up"
  And I should see "You have signed up successfully. However, we could not sign you in because your account is unconfirmed."
  
Scenario: A user unsuccessfully signs in with their email/password
  Given I am on the homepage
  When I follow "SIGN IN"
  And I fill in "Email" with "marcin.walczak@gmail.com"
  And I fill in "Password" with "verysecretpassword"
  And I press "Sign in"
  Then I should see "Invalid email or password"

@omniauth_test_success_facebook
Scenario: A user signs in with their email/password (facebook)
  Given I am on the homepage
  When I follow "Sign in with Facebook" image
  Then I should see "Successfully authorized from facebook account."
  
@omniauth_test_success_twitter
Scenario: A user signs in with their email/password (twitter)
  Given I am on the homepage
  When I follow "Sign in with Twitter" image
  Then I should see "Successfully authorized from twitter account."


  