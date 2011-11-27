Feature: Kudos sending

    Scenario: User can send/view a kudo
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
    When I go to the sent kudos path
    And I should see "Some message"


  Scenario: User cannot send a kudo - validation
  Given I'm logged in as a user with:
    | email             | password     | id |
    | user@example.net  | secret pass1 | 1  |
  And the following users exists:
    | email              | password     | id |
    | user2@example.net  | secret pass1 | 3  |
    | user3@example.net  | secret pass1 | 4  |
  When I go to the signed in users home page
  When I fill in "kudo_to" with "bad_recipient"
  And I press "Kudo_send_button" image button
  Then I should see "It seems like you have an invalid recipient/s on your list: bad_recipient"

