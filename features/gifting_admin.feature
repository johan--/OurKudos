Feature: Gifting administration


Scenario: Administrator can add Affiliate Programs
  Given I'm logged in as an administrator with:
    | email              | password     | id |
    | admin@example2.net | secret pass1 | 1  |
  When I go to admin area page
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
  And I follow "Merchants" 
  Then I should see "Disney Store"
  When I follow "Remove"
  Then I should not see "Disney Store"

Scenario: Administrator can edit a Merchant
  Given I'm logged in as an administrator with:
    | email              | password     | id |
    | admin@example2.net | secret pass1 | 1  |
  And the following merchants exist:
    | name           | homepage   |
    | Disney Store   | www.disneystore.com |
  When I go to the Merchants page
  Then I should see "Disney Store"
  When I follow "Edit"
  And I fill in "Name" with "The Disney Store"
  And I press "Update Merchant"
  Then I should see "The Disney Store"

Scenario: Administrator can add Gift Groups
  Given I'm logged in as an administrator with:
    | email              | password     | id |
    | admin@example2.net | secret pass1 | 1  |
  When I go to admin area page
  And I follow "Gift Groups"
  Then I should be on the Gift Groups page
  When I fill in "Group Name" with "Food Gifts"
  And I press "Add Group"
  Then I should see "Food Gifts"
  And I should be on the Gift Groups page

Scenario: Administrator can remove Gift Groups
  Given I'm logged in as an administrator with:
    | email              | password     | id |
    | admin@example2.net | secret pass1 | 1  |
  And the following Gift Groups exist:
    | name       |
    | Food Gifts |
  When I go to admin area page
  And I follow "Gift Groups"
  Then I should see "Food Gifts"
  When I follow "Remove"
  Then I should not see "Food Gifts"

Scenario: Administrator can add Gifts
  Given I'm logged in as an administrator with:
    | email              | password     | id |
    | admin@example2.net | secret pass1 | 1  |
  And the following merchants exist:
    | name         | homepage   |
    | Disney Store | www.disneystore.com |
  And the following gift groups exist:
    | name        |
    | Kids Gifts  |
    | Food Gifts  |
    | Movie Gifts |
    | Pet Gifts   |
  When I go to admin area page
  And I follow "Gifts"
  And I follow "Add Gift"
  And I fill in "Name" with "Fantasia"
  And I fill in "Description" with "Follow Yensid through a music journey"
  And I fill in "Price" with "19.99"
  And I select "Disney Store" from "Merchant"
  When I check "gift[gift_group_ids][]"
#When I check "gift[gift_group_ids][]" within "Gift Groups
  And I fill in "Affiliate Code" with "123abd"
  And I fill in "Link" with "www.disneystore.com/code123abc"
#And I attach "fantasia_disney.gif" to "Image"
  And I press "Create Gift"
  Then I should see "Fantasia"
  And I should see "Follow Yensid through a music journey"
  And I should see "19.99"
  And I should see "Disney Store"
  And I should see "Kids Gift"
  And I should see "123abc"
  And I should see "www.disneystore.com/code123abc"

Scenario: Administrator can delete Gifts
  Given I'm logged in as an administrator with:
    | email              | password     | id |
    | admin@example2.net | secret pass1 | 1  |
  And the following Gifts exist:
    | name      |
    | Fantasia  |
  When I go to admin area page
  And I follow "Gifts"
  Then I should see "Fantasia"
  When I follow "Remove" 
  Then I should not see "Fantasia"
  
