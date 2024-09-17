Feature: Withdraw
  Background:
    And user with status "Verified"
    And payment account isVerified="true"

  @SNGPAY-892
  Scenario: Send withdraw request with incorrect user_id
    Given withdraw request body with incorrect user id
    When send withdraw request
    Then withdraw response statusCode=200, code=125, message="AccountNotFound"

  @SNGPAY-893
  Scenario: Send withdraw request with incorrect account visual
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    Given withdraw request body with incorrect payment account visual
    When send withdraw request
    Then withdraw response statusCode=200, code=275, message="SuccessfulEmptyResultSet"

  @SNGPAY-894
  Scenario: Send withdraw request when payment account is not verified
    And payment account isVerified="false"
    Given withdraw request body with action approve
    When send withdraw request
    Then withdraw response statusCode=200, code=175, message="Payment account is not verified"

  @SNGPAY-895
  Scenario: Send withdraw request when user is blocked
    Given user with status "Blocked"
    And withdraw request body with action approve
    When send withdraw request
    Then withdraw response statusCode=200, code=131, message="User account is blocked"

  @SNGPAY-896
  Scenario: Send withdraw request when account is not verified from provider
    And provider mocked request customer-verification returns response with verificationLevel="9"
    Given withdraw request body with action approve
    When send withdraw request
    Then withdraw response statusCode=200, code=111, message="Provider Error"

  @SNGPAY-897
  Scenario: Send withdraw request when customer-verification service returns empty body
    And provider mocked request customer-verification returns empty body
    And withdraw request body with action approve
    When send withdraw request
    Then withdraw response statusCode=200, code=111, message="Provider Error"

  @SNGPAY-898
  Scenario: Send withdraw request when provider customer-verification service returns error
    And provider mocked request customer-verification failure
    And withdraw request body with action approve
    When send withdraw request
    Then withdraw response statusCode=200, code=111, message="Provider Error"

  @SNGPAY-899
  Scenario: Send withdraw request when rule engine actions equals pending
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"

  @SNGPAY-900
  Scenario: Send withdraw request when rule engine actions equals reject
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And withdraw request body with action reject
    When send withdraw request
    Then withdraw response statusCode=200, code=99, message="'REJECT' action is not allowed here"

  @SNGPAY-901
  Scenario: Send withdraw request when provider prepare request returns error
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And withdraw request body with action approve
    And provider mocked request pay.pl prepare error
    When send withdraw request
    Then withdraw response statusCode=200, code=111, message="Generic Failure"
    And check withdraw core transaction details in db, status="Rollback", fee="false"
    And check withdraw sis transaction details in db, status="FailedFromProvider", fee="false"

  @SNGPAY-902
  Scenario: Send withdraw request when provider prepare request returns empty response
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And withdraw request body with action approve
    And provider mocked request pay.pl prepare empty response
    When send withdraw request
    Then withdraw response statusCode=200, code=111, message="Generic Failure"
    And check withdraw core transaction details in db, status="Rollback", fee="false"
    And check withdraw sis transaction details in db, status="FailedFromProvider", fee="false"

  @SNGPAY-903
  Scenario: Send withdraw request when provider transfer request returns error
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And withdraw request body with action approve
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer error
    When send withdraw request
    Then withdraw response statusCode=200, code=111, message="Generic Failure"
    And check withdraw core transaction details in db, status="Rollback", fee="false"
    And check withdraw sis transaction details in db, status="FailedFromProvider", fee="false"

  @SNGPAY-904
  Scenario: Send withdraw request when provider transfer request returns empty response
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And withdraw request body with action approve
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer empty response
    When send withdraw request
    Then withdraw response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="false"
    And check withdraw sis transaction details in db, status="AmountWithdrawnFromCoreAccount", fee="false"

  @Smoke
  @SNGPAY-905
  Scenario Outline: Scenario: Send withdraw request success
    And provider mocked request customer-verification returns response with verificationLevel="<VerificationLevel>"
    And withdraw request body with action approve
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    When send withdraw request
    Then withdraw response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="false"
    And check withdraw sis transaction details in db, status="Finished", fee="false"

  Examples:
    | VerificationLevel |
    | 10                |
    | 11                |

  @Smoke
  @SNGPAY-906
  Scenario: Send withdraw request success with charge
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And withdraw request body with action approve and charge
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    When send withdraw request
    Then withdraw response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="true"
    And check withdraw sis transaction details in db, status="Finished", fee="true"

  @Smoke
  Scenario: Send withdraw request success with account_id
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And withdraw request body with action approve and account id
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    When send withdraw request
    Then withdraw response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="true"
    And check withdraw sis transaction details in db, status="Finished", fee="true"