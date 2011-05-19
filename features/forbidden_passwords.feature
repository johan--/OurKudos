Feature: Forbidden passwords management

Scenario: Administrator can add/remomve forbidden password to the list
    
    Given I'm logged in as an administrator with:
    | email             | password    | 
    | admin@example.net | somepass1   |
    When I go to the admin forbidden passwords page
    And I fill in "Password" with "Password1"
    And I press "Add to list"
    Then I should see "Password has been added to the list"
    When I follow "Remove it"
    Then I should see "Forbidden Password has been removed from the list"

Scenario: User tries to delete passwords

    Given I'm logged in as a user with:
    | email              | password   |
    | user@exampl2e.net  | somepass1  |
    And the following forbidden passwords exists:
        | password             |
        | administrator        |
        | editor               |
    When I go to the admin forbidden passwords page
    Then I should see "You are not authorized to access this page."

