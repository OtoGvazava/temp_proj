Feature: Auth Proxy

  Background:
    And user with status "Verified"

  @Smoke
  Scenario: AuthProxy init deposit
    When send core api login request
    Then check core api response http status code equals to 200
    And check core api response StatusCode equals to 10
    And check core api response ErrorCode equals to null
    Given auth proxy init deposit request body
    When send auth proxy init deposit request
    Then check auth proxy init deposit response http status code equals to 200
    And check auth proxy init deposit response code equals to 10
    And check auth proxy init deposit response message equals to "Success"

  @Smoke
  Scenario: AuthProxy deposit
    When send core api login request
    Then check core api response http status code equals to 200
    And check core api response StatusCode equals to 10
    And check core api response ErrorCode equals to null
    Given auth proxy init deposit request body
    When send auth proxy init deposit request
    Then check auth proxy init deposit response http status code equals to 200
    And check auth proxy init deposit response code equals to 10
    And check auth proxy init deposit response message equals to "Success"
    Given auth proxy deposit request body
    When send auth proxy deposit request
    Then check auth proxy deposit response http status code equals to 200
    And check auth proxy deposit response code equals to 10
    And check auth proxy deposit response message equals to "Success"

  @Smoke
  Scenario: AuthProxy init withdraw
    When send core api login request
    Then check core api response http status code equals to 200
    And check core api response StatusCode equals to 10
    And check core api response ErrorCode equals to null
    Given auth proxy init withdraw request body
    When send auth proxy init withdraw request
    Then check auth proxy init withdraw response http status code equals to 200
    And check auth proxy init withdraw response code equals to 10
    And check auth proxy init withdraw response message equals to "Success"

  @Smoke
  Scenario: AuthProxy withdraw
    When send core api login request
    Then check core api response http status code equals to 200
    And check core api response StatusCode equals to 10
    And check core api response ErrorCode equals to null
    Given auth proxy init withdraw request body
    When send auth proxy init withdraw request
    Then check auth proxy init withdraw response http status code equals to 200
    And check auth proxy init withdraw response code equals to 10
    And check auth proxy init withdraw response message equals to "Success"
    Given auth proxy withdraw request body
    When send auth proxy withdraw request
    Then check auth proxy withdraw response http status code equals to 200
    And check auth proxy withdraw response code equals to 10
    And check auth proxy withdraw response message equals to "Success"

  @Smoke
  Scenario: AuthProxy get payment accounts
    When send core api login request
    Then check core api response http status code equals to 200
    And check core api response StatusCode equals to 10
    And check core api response ErrorCode equals to null
    Given auth proxy get payment accounts request body
    When send auth proxy get payment accounts request
    Then check auth proxy get payment accounts response http status code equals to 200
    And check auth proxy get payment accounts response code equals to 10
    And check auth proxy get payment accounts response message equals to "Operation Successful"
    And check auth proxy get payment accounts response items size is more than zero

  @Smoke
  Scenario: AuthProxy get transaction details
    When send core api login request
    Then check core api response http status code equals to 200
    And check core api response StatusCode equals to 10
    And check core api response ErrorCode equals to null
    Given auth proxy init deposit request body
    When send auth proxy init deposit request
    Then check auth proxy init deposit response http status code equals to 200
    And check auth proxy init deposit response code equals to 10
    And check auth proxy init deposit response message equals to "Success"
    Given auth proxy deposit request body
    When send auth proxy deposit request
    Then check auth proxy deposit response http status code equals to 200
    And check auth proxy deposit response code equals to 10
    And check auth proxy deposit response message equals to "Success"
    Given auth proxy get transaction details request body
    When send auth proxy get transaction details request
    Then check auth proxy get transaction details response http status code equals to 200
    And check auth proxy get transaction details response code equals to 10
    And check auth proxy get transaction details response message equals to "Success"