Feature: Kudo Twitter Mentions

    @javascript
    Scenario: @mention gets added to recpient list
    Given I'm logged in as a user with:
      | email             | password     | id |
      | user@example.net  | secret pass1 | 1  |
    And the following users exists:
      | first_name  | last_name | id |
      | Kudos       | Mohawk    | 3  |
    And the following identities exists without validation:
      | user_id | identity| identity_type |
      | 3       | ourkudos | twitter       |
    And the following Kudo Categories exists:
      | name     |
      | Congrats |
    And jobs are being dispatched
    When I go to the signed in users home page
    And I fill in "kudo_message_textarea" with "Some message for @ourkudos"
    And I loose focus from the "#kudo_message_textarea" field
    Then I should see "[Kudos Mohawk] @ourkudos"

    @javascript
    Scenario: email address gets added to recpient list
    Given I'm logged in as a user with:
      | email             | password     | id |
      | user@example.net  | secret pass1 | 1  |
    And the following users exists:
      | first_name  | last_name | id |
      | Kudos       | Mohawk    | 3  |
    And the following identities exists without validation:
      | user_id | identity            | identity_type |
      | 3       | mohawk@ourkudos.com | email         |
    And jobs are being dispatched
    And I fill in "kudo_message_textarea" with "Some message for mohawk@ourkudos.com"
    And I loose focus from the "#kudo_message_textarea" field
    Then I should see "[Kudos Mohawk] mohawk@ourkudos.com"
