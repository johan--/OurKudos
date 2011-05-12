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
  Then I should see "In order to save your account, please provide missing information"
  And I fill in "Password confirmation" with "verysecretpassword"
  And I fill in "Password" with "verysecretpassword"
  And I press "Sign up"
  Then I should see "You have signed up successfully. However, we could not sign you in because your account is unconfirmed."
  
@omniauth_test_success_twitter
Scenario: A user signs in with their email/password (twitter)
  Given I am on the homepage
  When I follow "Sign in with Twitter" image
  Then I should see "In order to save your account, please provide missing information"
  When I fill in "Email" with "marcin@email.com"
  And I fill in "Password confirmation" with "verysecretpassword"
  And I fill in "Password" with "verysecretpassword"
  And I fill in "First name" with "Marcin"
  And I fill in "First name" with "Walczak"
  And I press "Sign up"
  Then I should see "You have signed up successfully. However, we could not sign you in because your account is unconfirmed."
  
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
    Then I should see "Authentication has been updated"
    
Scenario: Administrator can search users
  Given I'm logged in as an administrator with:
    | email             | password    | id | 
    | admin@example.net | secret pass | 1  |
  And the following users exists:
    | email              | password    | id | 
    | user@example.net   | secret pass | 2  |
    | user2@example.net  | secret pass | 3  |
    | user3@example.net  | secret pass | 4  |
  When I follow "Admin Area"
  And I follow "Users management"
  Then I should see "Email"
  And I should see "User name"
  And I should see "Last sign in at"
  And I should see "Sign in count"
  And I should see "User details"
  And I should see "Remove"
  And I should see "user@example.net"
  And I should see "user2@example.net"
  And I should see "user3@example.net"
  When I fill in "search" with "user@example.net"
  Then I should see "user@example.net"
  And I press "Search"
  And I should not see "user2@example.net"
  And I should not see "user3@example.net"
  
Scenario: Administrator can sort users
    Given I'm logged in as an administrator with:
      | email             | password    | id | 
      | admin@example.net | secret pass | 1  |
    And the following users exists:
      | email              | password    | id | 
      | user@example.net   | secret pass | 2  |
      | user2@example.net  | secret pass | 3  |
      | user3@example.net  | secret pass | 4  |
    When I follow "Admin Area"
    And I follow "Users management"
    And I follow "Email"
    Then "admin@example.net" should appear before "user2@example.net"  
    And "user2@example.net" should appear before "user@example.net"
    And "user3@example.net" should appear before "user@example.net"  
    And I follow "Email"
    Then "user@example.net" should appear before "user2@example.net"  
    And "user3@example.net" should appear before "user2@example.net"
    And "user@example.net" should appear before "admin@example.net"

Scenario: Administrator can remove users
  Given I'm logged in as an administrator with:
      | email             | password    | id | 
      | admin@example.net | secret pass | 1  |
  And the following users exists:
      | email              | password    | id | 
      | user@example.net   | secret pass | 2  |
      | user2@example.net  | secret pass | 3  |
      | user3@example.net  | secret pass | 4  |
  When I follow "Admin Area"
  And I follow "Users management"
  And I follow "Remove"
  Then I should see "User has been removed"
  And I should not see "user2@example.net"

Scenario: Administrator can display user details page
    Given I'm logged in as an administrator with:
        | email             | password    | id | 
        | admin@example.net | secret pass | 1  |
    And the following users exists:
        | email              | password    | id | 
        | user@example.net   | secret pass | 2  |
        | user2@example.net  | secret pass | 3  |
        | user3@example.net  | secret pass | 4  |
    When I follow "Admin Area"
    And I follow "Users management"
    And I follow "More details"
    Then I should see "Showing user admin@example.net"
    And I should see "Demographics"
    And I should see "Member since"
    And I should see "User last sign in IP"
    And I should see "Statistics"
    And I should see "Address"
    And I should see "Phone"
    And I should see "Mobile"

Scenario: Administrator can change user informations
    Given I'm logged in as an administrator with:
        | email             | password    | id | 
        | admin@example.net | secret pass | 1  |
    And the following users exists:
        | email              | password    | id | 
        | user@example.net   | secret pass | 2  |
        | user2@example.net  | secret pass | 3  |
        | user3@example.net  | secret pass | 4  |    
    When I follow "Admin Area"
    And I follow "Users management"
    And I follow "More details"
    And I fill in "user_mobile_number" with "123456789"
    And I press "Update settings"
    Then I should see "User data updated successfully"