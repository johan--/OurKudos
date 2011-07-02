Feature: Gifting administration


Scenario: Administrator can add Affiliate Programs
  Given I'm logged in as an administrator with:
    | email              | password     | id |
    | admin@example2.net | secret pass1 | 1  |
  When I go to admin area page
  And I follow "Gifting"
  And I follow "Affiliate Programs"
  Then I should be on the Affiliate Program page
  When I fill in "Name" with "Commission Junction"
  And I fill in "Homepage" with "www.cj.com"
  And I press "Create Affiliate Program"
  Then I should see "Commission Junction"
  And I should see "www.cj.com"
  And I should be on the Affiliate Program page

Scenario: Administrator can remove Affiliate Program
  Given I'm logged in as an administrator with:
    | email              | password     | id |
    | admin@example2.net | secret pass1 | 1  |
  And the following affiliate programs exist:
    | name                | homepage   |
    | Commission Junction | www.cj.com |
  When I go to admin area page
  And I follow "Gifting"
  And I follow "Affiliate Programs"
  Then I should see "Commission Junction"
  When I follow "Remove"
  Then I should not see "Commission Junction"

Scenario: Administrator can add mechants
  Given I'm logged in as an administrator with:
    | email              | password     | id |
    | admin@example2.net | secret pass1 | 1  |
  And the following affiliate programs exist:
    | name                | homepage   |
    | Commission Place    | www.cp.com |
  When I go to admin area page
  And I follow "Gifting"
  And I follow "Merchants"
  Then I should be on the Merchants page
  When I follow "Add Merchant"
  And I fill in "Name" with "Disney Store"
  And I fill in "Homepage" with "www.disneystore.com"
  And I fill in "Affiliate Code" with "123abc"
  And I fill in "Description" with "The place to shop"
  And I select "Commission Place" from "Affiliate Program"
  And I press "Create Merchant"
  Then I should see "Disney Store"
  And I should see "www.disneystore.com"
  And I should see "123abc"
  And I should see "The place to shop"
  And I should see "Commission Place"

Scenario: Administrator can remove Merchant
  Given I'm logged in as an administrator with:
    | email              | password     | id |
    | admin@example2.net | secret pass1 | 1  |
  And the following merchants exist:
    | name           | homepage   |
    | Disney Store   | www.disneystore.com |
  When I go to admin area page
  And I follow "Gifting"
  And I follow "Merchants" 
  Then I should see "Disney Store"
  When I follow "Remove"
  Then I should not see "Disney Store"
