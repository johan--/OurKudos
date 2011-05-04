Feature: Site keys management

Scenario: Administrator sees / can use management links
    
    Given I'm logged in as an administrator with:
    | email             | password    |
    | admin@example.net | secret pass |
    And the following site exists:
    | site_name    | protocol | url         | description | id |
    | my site      | http     | youtube.com | it's mine!  | 1  |
    And the following api key exists:
    | key                                                              | expires_at | site_id |
    | iDHZ0oRvQlZxWjQta1H6McUjE8ndGXDEWp8tUS70Ery13r13WdV7tXGJP23vRqsK | 2111-04-15 | 1       |
    When I go to that site's page
    Then I should see "Regenerate"
    And I should see "Disable"
    And I should see "Enable"
    And I should see "Remove"
    When I follow "Regenerate"
    Then I should see "Key has been updated"
    When I follow "Disable" 
    Then I should see "Key has been updated"
    When I follow "Enable" 
    Then I should see "Key has been updated"
    When I follow "Remove" 
    Then I should see "Key has been updated"
    When I follow "Add new api key for this site"
    Then I should see "Key has been added"
    

    