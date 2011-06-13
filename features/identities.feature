Feature: Identities management

Scenario: Administrator creates/edits/removes identity

    Given I'm logged in as an administrator with:
    | email             | password     |
    | admin@example.net | secret pass1 |
    When I go to the last user detail page
    And I follow "Add new identity"
    And I select "email" from "Identity type"
    And I fill in "Identity" with "my@secondary.email.com"
    And I press "Add new identity"
    Then I should see "Your identity has been successfully created"
    And I should see "my@secondary.email.com"
    When I follow "Edit"
    And I select "email" from "Identity type"
    And I fill in "Identity" with "my@secondary.other.email.com"
    And I press "Update Identity"
    Then I should see "Your identity has been successfully updated"
    And I should see "my@secondary.other.email.com"
    When I follow "Remove"
    Then I should see "Identity has been removed"

Scenario: User creates/edits/removes identity

    Given I'm logged in as a user with:
    | email             | password     |
    | user@example.net  | secret pass1 |
    When I follow "My Account"
    And I follow "Add new identity"
    And I select "email" from "Identity type"
    And I fill in "Identity" with "my@secondaryother.email.com"
    And I press "Add new identity"
    Then I should see "Your identity has been successfully created"
    When I follow "Edit"
    And I select "email" from "Identity type"
    And I fill in "Identity" with "my@secondary.other.email.com"
    And I press "Update Identity"
    Then I should see "Your identity has been successfully updated"
    And I should see "my@secondary.other.email.com"
    When I follow "Remove"
    Then I should see "Identity has been removed"