Feature: Default resource should exist for testing
  such we should define aws resources in code


  Scenario Outline: Naming Standard on all available resources
    Given I have <resource_name> defined
    Then it must contain <name_key>
    And its value must match the "(prod|test|dev)-testing-.*" regex

    Examples:
      | resource_name          | name_key |
      | AWS EC2 instance       | name     |
      | AWS ELB resource       | name     |
      | AWS RDS instance       | name     |
      | AWS S3 Bucket          | bucket   |
      | AWS EBS volume         | name     |
      | AWS Auto-Scaling Group | name     |
      | AWS Security Group     | name     |
      | aws_key_pair           | key_name |
      | aws_ecs_cluster        | name     |

  Scenario Outline: AWS Credentials should not be hardcoded
    Given I have aws provider configured
    When it contains <key>
    Then its value must not match the "<regex>" regex

    Examples:
      | key        | regex                                                      |
      | access_key | (?<![A-Z0-9])[A-Z0-9]{20}(?![A-Z0-9])                      |
      | secret_key | (?<![A-Za-z0-9\/+=])[A-Za-z0-9\/+=]{40}(?![A-Za-z0-9\/+=]) |

  Scenario Outline: Ensure that specific tags are defined
    Given I have resource that supports tags defined
    When it has tags
    Then it must contain <tags>
    And its value must match the "<value>" regex

    Examples:
      | tags        | value |
      | Name        | .+    |
      | Environment | .+    |
      | Project     | .+    |

  Scenario Outline: Ensure our SG an Ingress policy
    Given I have AWS Security Group defined
    Then it must contain <policy_name>

    Examples:
      | policy_name |
      | ingress     |

  Scenario: No publicly open ports
    Given I have AWS Security Group defined
    When it has ingress
    Then it must not have tcp protocol and port 1024-65535 for 0.0.0.0/0

  Scenario Outline: Well-known protocol exposure on Public Network for ingress traffic
    Given I have AWS Security Group defined
    When it has ingress
    Then it must not have <proto> protocol and port <portNumber> for 0.0.0.0/0

    Examples:
      | ProtocolName  | proto | portNumber |
      | Telnet        | tcp   | 23         |
      | SSH           | tcp   | 22         |
      | MySQL         | tcp   | 3306       |
      | MSSQL         | tcp   | 1443       |
      | NetBIOS       | tcp   | 139        |
      | RDP           | tcp   | 3389       |
      | Jenkins Slave | tcp   | 50000      |

  Scenario: Ensure my Instance has a security group
    Given I have aws_instance defined
    Then it must contain vpc_security_group_ids
    And its value must not be null

  Scenario: Ensure my Instance size is correct
    Given I have aws_instance defined
    Then it must contain instance_type
    And its value must be "t3.small"
