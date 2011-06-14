Feature: Kudos sending

    Scenario: User can send a kudo
    Given I'm logged in as a user with:
      | email             | password     | id |
      | user@example.net  | secret pass1 | 1  |
    And the following users exists:
      | email              | password     | id |
      | user2@example.net  | secret pass1 | 3  |
      | user3@example.net  | secret pass1 | 4  |
    And jobs are being dispatched
    When I go to the signed in users home page
    And I fill in "kudo_message_textarea" with "Some message"
    And I fill in "kudo_to" with "user2@example.net"
    And I press "Kudo_send_button" image button
    Then I should see "Your Kudo has been sent"