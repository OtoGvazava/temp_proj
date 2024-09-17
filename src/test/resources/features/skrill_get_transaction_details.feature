Feature: Get Transaction Details

  @Smoke
  Scenario: Get transaction details success
    Given consul properties
    And user id
    And provider id
    And service id
    And user with status "Verified"
    And deposit request body
    When send deposit request
    And provider mocked request customer-verification returns response with verificationLevel="10"
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given ruleEngine validation passed
    And deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    And check deposit core transaction details in db, status="Success", fee="false"
    And check deposit sis transaction details in db, status="Finished", fee="false"
    Given get transaction details request body
    When send get transaction request