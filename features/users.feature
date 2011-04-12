Feature: Users regristration / management

Scenario: User has automatically generated api key after regristration

  Given there are no users yet
  When I go to the home page
  And I follow "SIGN UP"
  And I fill in "Email" with "marcin.walczak@gmail.com"
  And I fill in "Password" with "verysecretpassword"
  And I fill in "Password confirmation" with "verysecretpassword"
  And I press "Sign up"
  Then I should receive an email
  And I should see "You have signed up successfully. If enabled, a confirmation was sent to your e-mail."
  And I should have "64"-length api key generated
  When I open the email
  Then I should see "Your Our Kudos api key is" in the email body
  When I click first link in the email
  Then I should see "Your account was successfully confirmed. You are now signed in." 