Feature: Flagged Kudos administration

  Scenario: Administrator can sort users
    Given I'm logged in as an administrator with:
      | email              | password     | id |
      | admin@example2.net | secret pass1 | 1  |
    And the following users exists:
      | email              | password     | first_name | id |
      | user@example.net   | secret pass1 | user1      | 2  |
    And user "2" has a flagged kudo
    When I go to admin area page
    And I follow "Flagged kudos"
    And I should see "user1"
    Then show me the page
    And I select "Suspend User" from "action"
    And I press "Go"
    Then I should see "user1 has been suspended"
