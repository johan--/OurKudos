Feature: System administration


Scenario: Administrator can search users
  Given I'm logged in as an administrator with:
    | email             | password     | id |
    | admin@example.net | secret pass1 | 1  |
  And the following users exists:
    | email              | password     | id |
    | user@example.net   | secret pass1 | 2  |
    | user2@example.net  | secret pass1 | 3  |
    | user3@example.net  | secret pass1 | 4  |
  When I go to admin area page
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
    When I go to admin area page
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
  And I go to admin area page
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
    And I go to admin area page
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
    And I go to admin area page
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

 Scenario: Administrator can change kudos social sharing
    Given I'm logged in as an administrator with:
        | email             | password     | id |
        | admin@example.net | secret pass1 | 1  |
    And the following users exists:
        | email              | password     | id |
        | user@example.net   | secret pass1 | 2  |
    And settings are seeded
    And I go to admin area page
    And I follow "Website options"
    And I choose "settings_value_no"
    And I press "Submit"
    Then I should see "Website Options updated."
    When I follow "Sign Out"
    And I follow "Sign in button" image
    And I fill in "Email" with "user@example.net"
    And I fill in "Password" with "secret pass1"
    And I press "Sign in"
    Then I should see "Administrator has disabled posting to social sites."