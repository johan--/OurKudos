Feature: Passwords recovery

  Scenario: User can recover password (without javascript/ no email to sign in used)
      Given I am on the home page
      And the following users exists:
      | email              | password     | id |
      | user@example.net   | secret pass1 | 2  |
      And I follow "Sign in button" image
      And I follow "Forgot your password?"
      And I fill in "user_email" with "user@example.net"
      And I press "Send me reset password instructions"
      Then I should see "You will receive an email with instructions about how to reset your password in a few minutes."

  Scenario: User can recover password (with email used to sign in / without javascript)
      Given I am on the home page
      And the following users exists:
      | email              | password     | id |
      | user@example.net   | secret pass1 | 2  |
      And I follow "Sign in button" image
      And I fill in "Email" with "user@example.net"
      And I fill in "Password" with "mysecretpasswrong"
      And I press "Sign in"
      Then I should see "Invalid email or password"
      When I follow "Forgot your password?"
      Then I should see "You will receive an email with instructions about how to reset your password in a few minutes."

  @javascript
  Scenario: User can recover password (with email used to sign in / with javascript)
      Given I am on the home page
      And the following users exists:
      | email              | password     | id |
      | user@example.net   | secret pass1 | 2  |
      When I go to the new user session page
      And I fill in "Email" with "user@example.net"
      And I wait about "5" seconds
      And I follow "Forgot your password?"
      Then I should see "You will receive an email with instructions about how to reset your password in a few minutes."



