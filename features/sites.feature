Feature: Sites  management

Scenario: Administrator creates new site

  Given I'm logged in as an administrator with:
  | email             | password    |
  | admin@example.net | secret pass |
  When I follow "Admin Area"
  And I follow "API Client Sites"
  And I follow "Add new client site"
  And I fill in "Site name" with "my great blog"
  And I select "http" from "site_protocol"
  And I fill in "Url" with "www.youtube.com"
  And I fill in "Description" with "Yes I am THE OWNER"
  And I press "Add new client site"
  Then I should see "Your site has been saved"
  And I should see "Site name"
  And I should see "Site url"
  And I should see "Api keys count"
  And I should see "blocked"
  And I should see "Site details"
 
 
Scenario: Administrator sees empty list

  Given I'm logged in as an administrator with:
  | email             | password    |
  | admin@example.net | secret pass |
  When I follow "Admin Area"
  And I follow "API Client Sites"
  Then I should see "No client sites yet"
  

Scenario: Administrator updates exiting site
  Given the following site exists:
  | site_name    | protocol | url         | description | id |
  | my site      | http     | youtube.com | it's mine!  | 1  |
  And the following api key exists:
  | key                                                              | expires_at | site_id |
  | iDHZ0oRvQlZxWjQta1H6McUjE8ndGXDEWp8tUS70Ery13r13WdV7tXGJP23vRqsK | 2111-04-15 | 1       |
  And I'm logged in as an administrator with:
  | email             | password    |
  | admin@example.net | secret pass |
  When I go to that site's page
  Then I should see "Site name"
  And I should see "Url"  
  And I should see "Description"
  And I should see "Back to sites listing"
  When I press "Update site"
  Then I should see "Site has been updated"

Scenario: Administrator cannot update site
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
    Then I should see "Site name"
    And I should see "Url"  
    And I should see "Description"
    And I should see "Back to sites listing"
    When I fill in "Site name" with ""
    And I press "Update site"
    Then I should see "Site name can't be blank"
  
    
  