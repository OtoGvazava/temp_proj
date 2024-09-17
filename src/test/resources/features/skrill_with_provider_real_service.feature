Feature: With provider real service

  Background:
    Given consul properties
    And user id
    And provider id
    And service id
    And user with status "Verified"

  Scenario: Success deposit
    And deposit request body for real provider request
    When send deposit request
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given ruleEngine validation passed
    And deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    And check deposit core transaction details in db, status="Success", fee="true"
    And check deposit sis transaction details in db, status="Finished", fee="true"

  Scenario: Success withdraw
    And withdraw request body with action approve with real endpoint
    When send withdraw request
    Then withdraw response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="false"
    And check withdraw sis transaction details in db, status="Finished", fee="false"

  Scenario Outline: Success Job
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="true"
    And check withdraw sis transaction details in db, status="Finished", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |