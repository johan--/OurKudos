Feature: Users regristration / management

Scenario: User has automatically generated api key after regristration

  Given there are no users yet
  When I go to the home page
  And I follow "SIGN UP"
  And I fill in "Email" with "marcin.walczak@gmail.com"
  And I fill in "Password" with "verysecretpassword"
  And I fill in "Password confirmation" with "verysecretpassword"
  And I press "Sign up"
  Then I should see "You have signed up successfully. If enabled, a confirmation was sent to your e-mail."
  And I should have "64"-length api key generated