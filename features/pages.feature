Feature: Pages management

Scenario: Administrator can add new page from CMS

    Given I'm logged in as an administrator with:
    | email             | password    |
    | admin@example.net | somepass1   |
    When I go to the admin pages page
    And there are no pages yet
