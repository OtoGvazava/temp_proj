Feature: Init Withdraw

  @Smoke
  Scenario: Success Init Withdraw
    And init withdraw request body
    When send init withdraw request
    Then init withdraw response statusCode=200, code=10, message="Success"

  Scenario: Init Withdraw Action is missing
    And init withdraw request body action missing
    When send init withdraw request
    Then init withdraw response statusCode=200, code=99, message="'Actions' must not be empty."

  Scenario: Init Withdraw Service Id is missing
    And init withdraw request body service_id missing
    When send init withdraw request
    Then init withdraw response statusCode=200, code=99, message="'service_id' must be greater than 0."

  Scenario: Init Withdraw hash is missing
    And init withdraw request body
    When send init withdraw request hash is missing
    Then init withdraw response statusCode=400, code=112, message="Missing mandatory headers"

  Scenario: Init Withdraw hash is incorrect
    And init withdraw request body
    When send init withdraw request hash is incorrect
    Then init withdraw response statusCode=200, code=139, message="Incorrect Hash"