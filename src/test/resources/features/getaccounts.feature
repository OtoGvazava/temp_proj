Feature: Get Accounts Request

  Background:
    And user with status "Verified"

    Scenario: Send get accounts request with incorrect user_id
      Given get accounts request body with incorrect user id
      When send get accounts request
      Then get accounts response statusCode=200, code=275, message="SuccessfulEmptyResultSet"
      And get accounts data object is empty

    Scenario: Send get accounts request with incorrect service_id
      Given get accounts request body with incorrect service id
      When send get accounts request
      Then get accounts response statusCode=200, code=10, message="Operation Successful"
      And get accounts data object is empty

    @Smoke
    Scenario: Send get accounts request with is_recurring equals true
      And get accounts request body with is_recurring="true"
      When send get accounts request
      Then get accounts response statusCode=200, code=10, message="Operation Successful"
      And get accounts data object is not empty
      # implement step to check if in get accounts response the account exists

    @Smoke
    Scenario: Send get accounts request with is_recurring equals false
      Given get accounts request body with is_recurring="false"
      When send get accounts request
      Then get accounts response statusCode=200, code=10, message="Operation Successful"
      And get accounts data object is not empty
      # implement step to check if in get accounts response the account exists

    Scenario: Send get accounts request when pay account is not verified
      Given get accounts request body with is_recurring="false"
      When send get accounts request
      Then get accounts response statusCode=200, code=10, message="Operation Successful"
      # implement step to check if in get accounts response the account doesnt exist

    Scenario: Send get accounts request when pay account status is blocked
      Given get accounts request body with is_recurring="false"
      When send get accounts request
      Then get accounts response statusCode=200, code=10, message="Operation Successful"
      # implement step to check if in get accounts response the account doesnt exist