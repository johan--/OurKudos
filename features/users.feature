Feature: Users regristration / management

Scenario: User can create an account natively
  Given there are no users yet
  When I go to the home page
  And I follow "Join Ourkudos now!" image
  And I fill in "Email" with "marcin.walczak@gmail.com"
  And I fill in "First name" with "Marcin"
  And I fill in "Last name" with "Walczak"
  And I fill in "signup_user_password" with "verysecretpassword1"
  And I fill in "user_postal_code" with "12345"
  And I press "new_registration_submit_btn"
  And I should see "You have signed up successfully. Please check your email and confirm your account"

Scenario: A user unsuccessfully signs in with their email/password
  Given I am on the homepage
  And settings are seeded 
  When I follow "Sign in button" image
  And I fill in "Email" with "marcin.walczak@gmail.com"
  And I fill in "Password" with "verysecretpassword1"
  And I press "sign_in_submit_btn"
  Then I should see "Incorrect Username and/or Password"

#Facebook auth no longer works this way.
#@omniauth_test_success_facebook
#Scenario: A user signs in with their email/password (facebook)
#  Given I am on the homepage
#  And settings are seeded 
#  When I follow "Connect with Facebook" image
#  And I fill in "signup_user_password" with "verysecretpassword1"
#  And I fill in "user_password_confirmation" with "verysecretpassword1"
#  And I press "Sign up"
#  Then I should see "You have signed up successfully. Please check your email and confirm your account"

@omniauth_test_success_twitter
Scenario: A user tries to sign up with its email/password (twitter)
  Given I am on the homepage
  And settings are seeded 
  And I follow "Sign in button" image
  When I follow "Sign in with Twitter" image
  Then I should see "No twitter account found!. You cannot create account using twitter, please sign up - using either facebook or native sign up method or sign in to your existing account, then click this icon again to create your twitter credentials"

Scenario: Editing a user profile
  Given I'm logged in as a user with:
    | email             | password     | id |
    | user@example.net  | secret pass1 | 1  |
  When I follow "My Account"
  And I follow "Edit my personal info"
  And I fill in "Street Address" with "726 Farr Court"
  And I fill in "Zip Code" with "54701"
  And I fill in "City" with "Eau Claire" 
  And I fill in "State/Province" with "Wisconsin"
  And I press "Update My Info"
  Then I should see "726 Farr Court"
  And I should see "54701"
  And I should see "Eau Claire"
  And I should see "Wisconsin"
