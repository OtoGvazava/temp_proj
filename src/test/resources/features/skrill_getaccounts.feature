Feature: Get Accounts Request

  Background:
    Given user id
    And service id
    And user with status "Verified"

    @SNGPAY-885
    Scenario: Send get accounts request with incorrect user_id
      Given get accounts request body with incorrect user id
      When send get accounts request
      Then get accounts response statusCode=200, code=275, message="SuccessfulEmptyResultSet"
      And get accounts data object is empty

    @SNGPAY-886
    Scenario: Send get accounts request with incorrect service_id
      Given get accounts request body with incorrect service id
      When send get accounts request
      Then get accounts response statusCode=200, code=10, message="Operation Successful"
      And get accounts data object is empty

    @SNGPAY-887
    @Smoke
    Scenario: Send get accounts request with is_recurring equals true
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
      And check deposit core transaction details in db, status="Success", fee="true"
      And check deposit sis transaction details in db, status="Finished", fee="true"
      Given payment account id from database
      And get accounts request body with is_recurring="true"
      When send get accounts request
      Then get accounts response statusCode=200, code=10, message="Operation Successful"
      And get accounts data object is not empty
      And get accounts data object includes payment account with id 7785 and visual "newskrilluser@ss.ss"
      And get accounts data object not includes payment account with id 7776

    @SNGPAY-888
    @Smoke
    Scenario: Send get accounts request with is_recurring equals false
      Given get accounts request body with is_recurring="false"
      When send get accounts request
      Then get accounts response statusCode=200, code=10, message="Operation Successful"
      And get accounts data object is not empty
      And get accounts data object includes payment account with id 7785 and visual "newskrilluser@ss.ss"
      And get accounts data object includes payment account with id 7776 and visual "newskrilluser@ss.ss"

    @SNGPAY-889
    Scenario: Send get accounts request when pay account is not verified
      Given get accounts request body with is_recurring="false"
      When send get accounts request
      Then get accounts response statusCode=200, code=10, message="Operation Successful"
      And get accounts data object not includes payment account with id 7384

    @SNGPAY-890
    Scenario: Send get accounts request when pay account status is blocked
      Given get accounts request body with is_recurring="false"
      When send get accounts request
      Then get accounts response statusCode=200, code=10, message="Operation Successful"
      And get accounts data object not includes payment account with id 7782