Feature: Init Deposit

  @Smoke
  Scenario: Init Deposit Success
    And init deposit request body
    When send init deposit request
    Then init deposit response statusCode=200, code=10, message="Success"

  Scenario: Init Deposit Action is missing
    And init deposit request body action missing
    When send init deposit request
    Then init deposit response statusCode=200, code=99, message="'Actions' must not be empty."

  Scenario: Init Deposit Service Id is missing
    And init deposit request body service_id missing
    When send init deposit request
    Then init deposit response statusCode=200, code=99, message="'service_id' must be greater than 0."

  Scenario: Init Deposit hash is missing
    And init deposit request body
    When send init deposit request hash is missing
    Then init deposit response statusCode=400, code=112, message="Missing mandatory headers"

  Scenario: Init Deposit hash is incorrect
    And init deposit request body
    When send init deposit request hash is incorrect
    Then init deposit response statusCode=200, code=139, message="Incorrect Hash"