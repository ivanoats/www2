Feature: Manage servers
  In order to manage and connect to hosting servers
  the server admin 
  wants to list and edit server info.
  
  Scenario: Register new server
    Given I am on the new server page
    When I fill in "Name" with "name 1"
    And I fill in "Ip address" with "ip_address 1"
    And I fill in "Vendor" with "vendor 1"
    And I fill in "Location" with "location 1"
    And I fill in "Primary ns" with "primary_ns 1"
    And I fill in "Primary ns ip" with "primary_ns_ip 1"
    And I fill in "Secondary ns" with "secondary_ns 1"
    And I fill in "Secondary ns ip" with "secondary_ns_ip 1"
    And I fill in "Max accounts" with "100"
    And I fill in "Whm user" with "whm_user 1"
    And I fill in "Whm pass" with "whm_pass 1"
    And I fill in "Whm key" with "whm_key 1"
    And I press "Create"
    Then I should see "name 1"
    And I should see "ip_address 1"
    And I should see "vendor 1"
    And I should see "location 1"
    And I should see "primary_ns 1"
    And I should see "primary_ns_ip 1"
    And I should see "secondary_ns 1"
    And I should see "secondary_ns_ip 1"
    And I should see "100"
    And I should see "whm_user 1"
    And I should see "whm_pass 1"
    And I should see "whm_key 1"

  Scenario: Delete server
    Given the following servers:
      |name|ip_address|vendor|location|primary_ns|primary_ns_ip|secondary_ns|secondary_ns_ip|max_accounts|whm_user|whm_pass|whm_key|
      |name 1|ip_address 1|vendor 1|location 1|primary_ns 1|primary_ns_ip 1|secondary_ns 1|secondary_ns_ip 1|100|whm_user 1|whm_pass 1|whm_key 1|
      |name 2|ip_address 2|vendor 2|location 2|primary_ns 2|primary_ns_ip 2|secondary_ns 2|secondary_ns_ip 2|100|whm_user 2|whm_pass 2|whm_key 2|
      |name 3|ip_address 3|vendor 3|location 3|primary_ns 3|primary_ns_ip 3|secondary_ns 3|secondary_ns_ip 3|100|whm_user 3|whm_pass 3|whm_key 3|
      |name 4|ip_address 4|vendor 4|location 4|primary_ns 4|primary_ns_ip 4|secondary_ns 4|secondary_ns_ip 4|100|whm_user 4|whm_pass 4|whm_key 4|
    When I delete the 3rd server
    Then I should see the following servers:
      |name|ip_address|vendor|location|primary_ns|primary_ns_ip|secondary_ns|secondary_ns_ip|max_accounts|whm_user|whm_pass|whm_key|
      |name 1|ip_address 1|vendor 1|location 1|primary_ns 1|primary_ns_ip 1|secondary_ns 1|secondary_ns_ip 1|100|whm_user 1|whm_pass 1|whm_key 1|
      |name 2|ip_address 2|vendor 2|location 2|primary_ns 2|primary_ns_ip 2|secondary_ns 2|secondary_ns_ip 2|100|whm_user 2|whm_pass 2|whm_key 2|
      |name 4|ip_address 4|vendor 4|location 4|primary_ns 4|primary_ns_ip 4|secondary_ns 4|secondary_ns_ip 4|100|whm_user 4|whm_pass 4|whm_key 4|
