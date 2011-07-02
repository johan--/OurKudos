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
