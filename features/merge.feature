Feature: Accounts Merging

Scenario: User can merge its account
    
    Given I'm logged in as a user with
    | email             | password    | 
    | user@example.net  | somepass |
    When I go to the home page
    And I follow "Merge my accounts"
    Then I should see "Your current account - the one you're currently signed in will be updated to receive and manage kudos on behalf of merged account. Merged account will be deleted, and all your identities will be transfered to current account. Please keep in mind that administrative accounts cannot be removed, thus you can only merge them as your primary account"
    
    