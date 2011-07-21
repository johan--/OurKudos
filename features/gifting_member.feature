Feature: Gifting administration

Scenario: Accessing the Gifting page
  Given the following Gifts exist:
    | name      |
    | Fantasia  |
  And the following gift groups exist:
    | name        |
    | Kids Gifts  |
    | Food Gifts  |
    | Movie Gifts |
    | Pet Gifts   |
  And I am on the homepage
  And I go to the public Gifts page
  Then I should see "Fantasia"

@javascript
Scenario: Filtering the group lists
  Given the a set of Gifts and Groups exist:
  When I go to the public Gifts page
  Then I should see "group1"
  When I follow "group1"
  Then I should see "group_gift"
  And I should not see "gift1"

@javascript
Scenario: Loading a gift to the gift area
  Given the a set of Gifts and Groups exist:
  When I go to the public Gifts page
  Then I should see "group_gift"
  When I follow "group_gift"
  Then I should see "testdescription"
  When I follow "gift1"
  And I should not see "testdescription"
