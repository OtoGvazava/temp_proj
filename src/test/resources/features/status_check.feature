Feature: Status Check

  @Smoke
  Scenario: Success Status Check
    # add step to mock provider request to return success response
    When send status check request
    Then status check response statusCode=200, code=10, message="Success"
    And check status check response data