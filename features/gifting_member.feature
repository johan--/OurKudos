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
