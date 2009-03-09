Feature: Manage comments
  In order to have the commenting ability on articles
  As a web visitor
  I Want the ability to post comments #and eventually, list, edit, and delete comments
  
  Scenario: Register new comment
    Given I am on an article page
    When I fill in "Name" with "name 1"
    And I fill in "Email" with "email@email.com"
    And I fill in "Comment" with "comment 1"
    And I press "Add comment"
    Then I should see "name 1"
    And I should see "comment 1"

  # Scenario: Delete comment
  #   Given the following comments:
  #     |name|comment|
  #     |name 1|comment 1|
  #     |name 2|comment 2|
  #     |name 3|comment 3|
  #     |name 4|comment 4|
  #   When I delete the 3rd comment
  #   Then I should see the following comments:
  #     |name|comment|
  #     |name 1|comment 1|
  #     |name 2|comment 2|
  #     |name 4|comment 4|
