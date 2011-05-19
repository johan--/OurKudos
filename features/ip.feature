Feature: Ip throttling

Scenario: User Ip is blocked after 5 failed attempts
    

    Given the following users exists:
     | email              | password     |
     | user5@example.net  | secretpass1  |
     | user3@example.net  | secretpass1  |
    And I tried to login with "user5@example.net" email "5" times unsuccessfully
    When I go to the new user session page
    And  I fill in "Email" with "user5@example.net"
    And  I fill in "Password" with "wrongpass"
    And  I press "Sign in"
    Then I should see "This IP address has been locked for another 18.0 seconds"
    When  I fill in "Email" with "user5@example.net"
    And  I fill in "Password" with "secretpass1"
    And  I press "Sign in"
    Then I should see "This IP address has been locked for another 28.0 seconds"
  
    