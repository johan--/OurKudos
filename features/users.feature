Feature: Users regristration / management

Scenario: User can create an account natively
  Given there are no users yet
  When I go to the home page
  And I follow "Join Ourkudos now!" image
  And I fill in "Email" with "marcin.walczak@gmail.com"
  And I fill in "First name" with "Marcin"
  And I fill in "Last name" with "Walczak"
  And I fill in "signup_user_password" with "verysecretpassword1"
  And I fill in "user_password_confirmation" with "verysecretpassword1"
  And I press "Sign up"
  And I should see "You have signed up successfully. Please check your email and confirm your account"

Scenario: A user unsuccessfully signs in with their email/password
  Given I am on the homepage
  When I follow "Sign in button" image
  And I fill in "Email" with "marcin.walczak@gmail.com"
  And I fill in "Password" with "verysecretpassword1"
  And I press "Sign in"
  Then I should see "Invalid email or password"

@omniauth_test_success_facebook
Scenario: A user signs in with their email/password (facebook)
  Given I am on the homepage
  When I follow "Connect with Facebook" image
  Then show me the page
  And I fill in "signup_user_password" with "verysecretpassword1"
  And I fill in "user_password_confirmation" with "verysecretpassword1"
  And I press "Sign up"
  Then I should see "You have signed up successfully. Please check your email and confirm your account"

@omniauth_test_success_twitter
Scenario: A user tries to sign up with its email/password (twitter)
  Given I am on the homepage
  And I follow "Sign in button" image
  When I follow "Sign in with Twitter" image
  Then I should see "No twitter account found!. You cannot create account using twitter, please sign up - using either facebook or native sign up method or sign in to your existing account, then click this icon again to create your twitter credentials"
