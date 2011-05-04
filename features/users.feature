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
  Then I should see "No such user"

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

Scenario: User removes it's own provider
   Given I'm logged in as a user with:
    | email             | password    | id | 
    | admin@example.net | secret pass | 1  |
   And the following authentication exists:
   | user_id | provider | token       | secret    |
   |  1      | facebook | screttoken  | secretkey |
   When I follow "My account"
   Then I should see "My authorizations"
   When I follow "Remove"
   Then I should see "Authentication has been removed"   
  
Scenario: User adds it's own provider
  Given I'm logged in as a user with:
    | email             | password    |
    | admin@example.net | secret pass |
  When I follow "My account"
  Then I should see "My authorizations"
  When I follow "Add new authentication"
  And I select "Facebook" from "Provider"
  And I fill in "Provider UID" with "my uid"
  And I fill in "Provider token" with "my token"
  And I fill in "Provider secret" with "my secret"
  And I press "Add new authentication"
  Then I should see "Authentication has been added" 
  And I should see "Provider"
  And I should see "Provider UID"
  And I should see "Provider token"
  And I should see "Edit"
  And I should see "Remove"
  And I should see "my uid"
  And I should see "my token"
  And I should see "my secret"


Scenario: User sees empty providers list
    Given I'm logged in as a user with:
      | email             | password    |
      | admin@example.net | secret pass |  
    When I follow "My account"
    Then I should see "My authorizations"  
    Then I should see "No authorizations yet"


Scenario: User edits it's own provider
  Given I'm logged in as a user with:
    | email             | password    | id | 
    | admin@example.net | secret pass | 1  |
    And the following authentication exists:
    | user_id | provider | token       | secret    |
    |  1      | facebook | screttoken  | secretkey |   
    When I follow "My account"
    Then I should see "My authorizations"
    When I follow "Edit"
    And I select "Twitter" from "Provider"
    And I press "Update provider"
    Then show me the page
    Then I should see "Authentication has been updated"
  
  