Feature: Gifting administration


Scenario: Administrator can add Affiliate Programs
    Given I'm logged in as an administrator with:
      | email              | password     | id |
      | admin@example2.net | secret pass1 | 1  |
    When I go to admin area page
    And I follow "Gifting"
    And I follow "Add Affiliate Program"
    Then I should be on the new Affiliate Program page
