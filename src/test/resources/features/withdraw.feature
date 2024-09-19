Feature: Withdraw

  Background:
    And user with status "Verified"
    And payment account isVerified="true"

  Scenario: Send withdraw request with incorrect user_id

  Scenario: Send withdraw request with incorrect account visual

  Scenario: Send withdraw request when payment account is not verified

  Scenario: Send withdraw request when user is blocked

  Scenario: Send withdraw request when rule engine actions equals pending

  Scenario: Send withdraw request when rule engine actions equals reject

  @Smoke
  Scenario: Send withdraw request success
    # should add some mock steps for provider requests
    And withdraw request body
    When send withdraw request
    Then withdraw response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="false"
    And check withdraw sis transaction details in db, status="Finished", fee="false"

  @Smoke
  Scenario: Send withdraw request success with charge