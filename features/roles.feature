Feature: Roles management

Scenario: Administrator can create roles
    
    Given I'm logged in as an administrator with:
    | email             | password    | 
    | admin@example.net | somepass |
    When I go to the admin roles page
    And I fill in "Name" with "Administrator"
    And I press "Create"
    Then I should see "Role has been created"

Scenario: User tries to delete roles

    Given I'm logged in as a user with:
    | email              | password    |
    | user@exampl2e.net | somepass    |
    And the following roles exists:
        | name             |
        | administrator    |
        | editor           |
    When I go to the admin roles page    
    Then I should see "You are not authorized to access this page."

