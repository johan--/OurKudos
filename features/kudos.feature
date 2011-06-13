Feature: Kudos sending

    Scenario: User can send a kudo
    Given I'm logged in as an administrator with:
      | email             | password     | id |
      | admin@example.net | secret pass1 | 1  |
    And the following users exists:
