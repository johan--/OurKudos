Feature: Users regristration / management

Scenario: User can create an account natively
  Given there are no users yet
  When I go to the home page
  And I follow "SIGN UP"
  And I fill in "Email" with "marcin.walczak@gmail.com"
  And I fill in "First name" with "Marcin"
  And I fill in "Last name" with "Walczak"
  And I fill in "Password" with "verysecretpassword1"
  And I fill in "Password confirmation" with "verysecretpassword1"
  And I press "Sign up"
  And I should see "You have signed up successfully. Please check your email and confirm your account"
  
Scenario: A user unsuccessfully signs in with their email/password
  Given I am on the homepage
  When I follow "SIGN IN"
  And I fill in "Email" with "marcin.walczak@gmail.com"
  And I fill in "Password" with "verysecretpassword1"
  And I press "Sign in"
  Then I should see "Invalid email or password"

@omniauth_test_success_facebook
Scenario: A user signs in with their email/password (facebook)
  Given I am on the homepage
  When I follow "Sign in with Facebook" image
  Then I should see "In order to save your account, please provide missing information"
  And I fill in "Password confirmation" with "verysecretpassword1"
  And I fill in "Password" with "verysecretpassword1"
  And I press "Sign up"
  Then I should see "You have signed up successfully. Please check your email and confirm your account"
  
@omniauth_test_success_twitter
Scenario: A user tries to sign up with its email/password (twitter)
  Given I am on the homepage
  When I follow "Sign in with Twitter" image  
  Then I should see "No twitter account found!. You cannot create account using twitter, please sign up - using either facebook or native sing up method or sign in to your existing account, then click this icon again to create your twitter credentials"

@omniauth_test_success_twitter
Scenario: A user signs in with their email/password (twitter) (user existis)
  Given I'm logged in as a user with:
    | email             | password     | id |
    | admin@example.net | secret pass1 | 1  |
  When I follow "Sign in with Twitter" image  
  Then I should see "Account connected"
  When I follow "SIGN OUT"
  And I follow "Sign in with Twitter" image
  Then I should see "Successfully authorized from twitter account."

Scenario: Administrator can search users
  Given I'm logged in as an administrator with:
    | email             | password     | id |
    | admin@example.net | secret pass1 | 1  |
  And the following users exists:
    | email              | password     | id |
    | user@example.net   | secret pass1 | 2  |
    | user2@example.net  | secret pass1 | 3  |
    | user3@example.net  | secret pass1 | 4  |
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
      | email             | password     | id |
      | admin@example.net | secret pass1 | 1  |
    And the following users exists:
      | email              | password     | id |
      | user@example.net   | secret pass1 | 2  |
      | user2@example.net  | secret pass1 | 3  |
      | user3@example.net  | secret pass1 | 4  |
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
      | email             | password     | id |
      | admin@example.net | secret pass1 | 1  |
  And the following users exists:
      | email              | password     | id |
      | user@example.net   | secret pass1 | 2  |
      | user2@example.net  | secret pass1 | 3  |
      | user3@example.net  | secret pass1 | 4  |
  When I follow "Admin Area"
  And I follow "Users management"
  And I follow "Remove"
  Then I should see "User has been removed"
  And I should not see "user2@example.net"

Scenario: Administrator can display user details page
    Given I'm logged in as an administrator with:
        | email             | password     | id |
        | admin@example.net | secret pass1 | 1  |
    And the following users exists:
        | email              | password     | id |
        | user@example.net   | secret pass1 | 2  |
        | user2@example.net  | secret pass1 | 3  |
        | user3@example.net  | secret pass1 | 4  |
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
        | email             | password     | id |
        | admin@example.net | secret pass1 | 1  |
    And the following users exists:
        | email              | password     | id |
        | user@example.net   | secret pass1 | 2  |
        | user2@example.net  | secret pass1 | 3  |
        | user3@example.net  | secret pass1 | 4  |
    When I follow "Admin Area"
    And I follow "Users management"
    And I follow "More details"
    And I fill in "user_mobile_number" with "123456789"
    And I press "Update settings"
    Then I should see "User data updated successfully"

Scenario: Administrator can add/remove user roles
    Given I'm logged in as an administrator with:
        | email             | password     | id |
        | admin@example.net | secret pass1 | 1  |
    And the following users exists:
        | email              | password     | id |
        | user@example.net   | secret pass1 | 2  |
        | user2@example.net  | secret pass1 | 3  |
        | user3@example.net  | secret pass1 | 4  |
    And the following roles exists:
        | name          |
        | some role 1   |
        | some role 2   |
    When I go to the last user detail page    
    And I follow "Change/manage user roles"
    Then I should see "Please Select Roles To Update"
    When I check "some role 1"
    And I check "some role 2"
    And I press "Update user roles"
    Then I should see "User data updated successfully"
    When I go to the last user detail page
    Then I should see "some role 1, some role 2"
    When I follow "Change/manage user roles"
    And I uncheck "some role 1"
    And I uncheck "some role 2"
    And I press "Update user roles"
    Then I should see "User data updated successfully"
    When I go to the last user detail page
    Then I should not see "some role 1, some role 2"
