Feature: Deposit

  @Smoke
  Scenario: Success deposit
    And user with status "Verified"
    And provider example post request returns success response
    And ruleEngine validation passed
    And deposit request body
    When send deposit request
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    # maybe some callback steps
    And check deposit core transaction details in db, status="Success", fee="false"
    And check deposit sis transaction details in db, status="Finished", fee="false"

  Scenario: Deposit when RuleEngine rejects on callback

  Scenario: Deposit when RuleEngine pending on callback

  @Smoke
  Scenario: Success deposit with charge

  Scenario: Success deposit when payment account exists

  Scenario: Success deposit when payment account exists and is not verified

  Scenario: Deposit when user_id is incorrect

  Scenario: Deposit when user is blocked
    And user with status "Blocked"

  Scenario: Deposit when account is not verified from provider

  Scenario: Deposit when rule engine actions equals pending
    And user with status "Verified"

  Scenario: Deposit when rule engine actions equals reject

  Scenario: Deposit when currency is invalid

  Scenario: Deposit callback with incorrect transaction id

  Scenario: Deposit when deposit and callback requests has different amount value

  Scenario: Deposit when deposit and callback requests has different currency value