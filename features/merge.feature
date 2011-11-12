Feature: Accounts Merging

Scenario: User can merge its accounts

    Given I'm logged in as a user with:
      | email                    | password     |
      | currentuser@example.net  | secret pass1 |
    And the following users exists:
     | email              | password     |
     | example@example.com  | secretpass1  |
     | user3@example.net  | secretpass1  |
    When I follow "My Account"
    And I follow "Merge my accounts"
    Then I should see "Your current account - the one you're currently signed in will be updated to receive and manage kudos on behalf of merged account. Merged account will be deleted, and all your identities will be transfered to current account. Please keep in mind that administrative accounts cannot be removed, thus you can only merge them as your primary account"
    When I fill in "Enter Account Identity" with "example@example.com"
    And I fill in "merge_password" with "secretpass1"
    And I press "Merge my current account with this account"
    Then I should see "Message has been sent. For further instructions, please check email address associated with your merge account"
    #And "example@example.com" should receive an email with subject "[OurKudos] - Please confirm, that you are account owner"
    #When I open the email with subject "[OurKudos] - Please confirm, that you are account owner"
    When I open the email
    Then I should see "Confirm it!" in the email body
    When I follow "Confirm it" in the email
    Then I should see "You have successfully confirmed your"
    And I should see "Click Button Below To Merge Your Accounts"
    And I should see "Merge your accounts"
    When I press "Merge my accounts"
    Then I should see "You have successfuly merged your accounts"

Scenario: User can merge its virtual email accounts
    Given I'm logged in as a user with:
      | email                    | password     |
      | currentuser@example.net  | secret pass1 |
    And the following virtual users exists:
      | first_name | last_name  | id |
      | bob        | smith      | 1  |
    And the following identities exists:
      | identity           | Identity_type | identifiable_id | identifiable_type | is_primary |
     | example@example.com | email         | 1               | VirtualUser       | false |
    When I follow "My Account"
    And I follow "Merge my accounts"
    And I fill in "Unconfirmed Identity" with "example@example.com"
    And I press "Merge unconfirmed account with my account"
    Then I should see "Message has been sent. For further instructions, please check email address associated with your merge account"
    #And "example@example.com" should receive an email with subject "[OurKudos] - Please confirm, that you are account owner"
    #When I open the email with subject "[OurKudos] - Please confirm, that you are account owner"
    When I open the email
    Then I should see "Confirm it!" in the email body
    When I follow "Confirm it" in the email
    Then I should see "You have successfully confirmed your"
    And I should see "Click Button Below To Merge Your Accounts"
    And I should see "Merge your accounts"
    When I press "Merge my accounts"
    Then I should see "You have successfuly merged your accounts"


Scenario: User attemping to merge twitter account not in system
    Given I'm logged in as a user with:
      | email                    | password     |
      | currentuser@example.net  | secret pass1 |
    And jobs are being dispatched
    When I follow "My Account"
    And I follow "Merge my accounts"
    And I fill in "Unconfirmed Identity" with "example@example.com"
    And I press "Merge unconfirmed account with my account"
    Then I should see "There was a problem merging you account"

Scenario: User attempting to merge twitter handle without authorizing twitter
    Given I'm logged in as a user with:
      | email                    | password     |
      | currentuser@example.net  | secret pass1 |
    And the following virtual users exists:
      | first_name | last_name  | id |
      | bob        | smith      | 1  |
    And the following confirmed identities exists:
      | identity  | identity_type | identifiable_id | identifiable_type | is_primary |
     | @stevejobs | twitter       | 1               | VirtualUser       | false |
    When I follow "My Account"
    And I follow "Merge my accounts"
    And I fill in "Unconfirmed Identity" with "@stevejobs"
    And I press "Merge unconfirmed account with my account"
    Then I should see "There was a problem merging you account"

Scenario: User can join from existing virtual user
  Given I'm logged in as a user with:
    | email                    | password     |
    | currentuser@example.net  | secret pass1 |
  And the following pages exists:
    | slug             | 
    | terms-of-service | 
  And jobs are being dispatched
  And settings are seeded
  When I go to the signed in users home page
  And I fill in "kudo_message_textarea" with "Some message"
  And I fill in "kudo_to" with "example@example.com"
  And I press "Kudo_send_button" image button
  #When I open the email with subject "[OurKudos] - Please confirm, that you are account owner"
  And no one is logged in
  Then I should have 1 email
  When I open the email
  When I follow "Reply to this message on OurKudos" in the email
  And I go to the new user registration page
  And I fill in "Email" with "example@example.com"
  And I fill in "First name" with "Steve"
  And I fill in "Last name" with "Jobs"
  And I fill in "signup_user_password" with "secret1"
  And I fill in "user_postal_code" with "54701"
  And I press "new_registration_submit_btn"
  Then I should see "You have successfuly merged your accounts"

  Scenario:

