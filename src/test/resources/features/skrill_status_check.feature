Feature: Status Check

  @Smoke
  Scenario: Success Status Check
    Given consul properties
    And user id
    And provider id
    And service id
    And user with status "Verified"
    And deposit request body with charge
    When send deposit request
    And provider mocked request customer-verification returns response with verificationLevel="10"
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given ruleEngine validation passed
    And deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    Given provider mocked request query.pl transfer status success
    When send status check request
    Then status check response statusCode=200, code=10, message="Success"
    And check status check response data