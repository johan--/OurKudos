Feature: Accounts Merging

Scenario: User can merge its accounts

    Given I'm logged in as a user with:
      | email             | password    |
      | user@example.net  | secret pass |
    And the following users exists:
     | email              | password    | id |    
     | user2@example.net  | secret pass | 3  |
     | user3@example.net  | secret pass | 4  |
    When I go to the home page    
    And I follow "Merge my accounts"
    Then I should see "Your current account - the one you're currently signed in will be updated to receive and manage kudos on behalf of merged account. Merged account will be deleted, and all your identities will be transfered to current account. Please keep in mind that administrative accounts cannot be removed, thus you can only merge them as your primary account"
    When I fill in "Enter Account Identity" with "user2@example.net"
    And I press "Merge my current account with this account"
    Then I should see "Message has been sent. For further instructions, please check email address associated with your merge account"
    And "user2@example.net" should receive an email
    When I open the email
    Then I should see "Confirm it!" in the email body
    When I follow "Confirm it" in the email
    Then I should see "Your identity has been successfuly confirmed!"
    And I should see "Click Button Below To Merge Your Accounts"
    And I should see "Merge your accounts"
    When I press "Merge my accounts"
    Then I should see "You have successfuly merged your accounts"


    
    