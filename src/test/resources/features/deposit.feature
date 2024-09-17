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
    Given deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=200, code=10, message="Success"
    And check deposit core transaction details in db, status="Success", fee="false"
    And check deposit sis transaction details in db, status="Finished", fee="false"

  Scenario: Deposit when RuleEngine rejects on callback
    And user with status "Verified"
    And ruleEngine validation passed
    And deposit request body
    When send deposit request
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    And check deposit response data parameters
    Given ruleEngine validation rejected
    And deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=202, code=111, message="Transaction rejected by rule engine"
    And check deposit sis transaction details in db, status="RollbackFailed", fee="false"

  Scenario: Deposit when RuleEngine pending on callback
    And user with status "Verified"
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And ruleEngine validation passed
    And deposit request body
    When send deposit request
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given ruleEngine validation pending
    And deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=202, code=182, message="TransactionStatusPending"
    And check deposit response data parameters
    And check deposit core transaction details in db, status="Pending", fee="false"
    And check deposit sis transaction details in db, status="AmountWithdrawFromProviderAccount", fee="false"

  @Smoke
  Scenario: Success deposit with charge
    And user with status "Verified"
    And deposit request body with charge
    And ruleEngine validation passed with charge
    When send deposit request
    And provider mocked request customer-verification returns response with verificationLevel="10"
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    And check deposit response data parameters
    Given deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="Finished", fee="true"
    And check deposit core transaction details in db, status="Success", fee="true"

  @SNGPAY-1634
  Scenario: Success deposit when payment account exists
    And user with status "Verified"
    And deposit request body with charge
    When send deposit request
    And provider mocked request customer-verification returns response with verificationLevel="10"
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given ruleEngine validation passed with charge
    And deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    And check deposit core transaction details in db, status="Success", fee="true"
    And check deposit sis transaction details in db, status="Finished", fee="true"
    When send deposit request
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    And deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    And check deposit core transaction details in db, status="Success", fee="true"
    And check deposit sis transaction details in db, status="Finished", fee="true"

  @SNGPAY-1635
  Scenario: Success deposit when payment account exists and is not verified
    And user with status "Verified"
    And deposit request body with charge
    When send deposit request
    And provider mocked request customer-verification returns response with verificationLevel="10"
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given ruleEngine validation passed with charge
    And deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    And check deposit core transaction details in db, status="Success", fee="true"
    And check deposit sis transaction details in db, status="Finished", fee="true"
    When send deposit request
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    And payment account id from database
    And payment account isVerified="false" by id
    And deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    And check deposit core transaction details in db, status="Success", fee="true"
    And check deposit sis transaction details in db, status="Finished", fee="true"

  @SNGPAY-1636
  @Smoke
  Scenario: Success Deposit with account id param
    And user with status "Verified"
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And deposit request body
    When send deposit request
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given ruleEngine validation passed with charge
    And deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    And check deposit core transaction details in db, status="Success", fee="false"
    And check deposit sis transaction details in db, status="Finished", fee="false"
    And payment account id from database
    And deposit request body with pay account id
    When send deposit request
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    And deposit callback request params with status Success
    When send deposit callback request
    Then deposit callback response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    And check deposit core transaction details in db, status="Success", fee="true"
    And check deposit sis transaction details in db, status="Finished", fee="true"

  @SNGPAY-1637
  Scenario: Deposit request without account and account_id params
    And user with status "Verified"
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And deposit request body without account and account_id params
    When send deposit request
    Then deposit response statusCode=200, code=99, message="UserIdentifier for Vendor UserInfoCheck not found"

  @SNGPAY-1638
  Scenario: Deposit request with incorrect account_id param
    And user with status "Verified"
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And deposit request body with incorrect pay account id
    When send deposit request
    Then deposit response statusCode=200, code=174, message="Payment account does not exist"

  @SNGPAY-1639
  Scenario: Deposit when user_id is incorrect
    And deposit request body with incorrect user_id
    When send deposit request
    Then deposit response statusCode=200, code=125, message="AccountNotFound"

  @SNGPAY-1640
  Scenario: Deposit when user is blocked
    And user with status "Blocked"
    And deposit request body
    When send deposit request
    Then deposit response statusCode=200, code=131, message="User account is blocked"

  @SNGPAY-1641
  Scenario: Deposit when customer-verification service returns empty body
    And user with status "Verified"
    And provider mocked request customer-verification returns empty body
    And deposit request body
    When send deposit request
    Then deposit response statusCode=200, code=111, message="Provider Error"

  @SNGPAY-1642
  Scenario: Deposit when provider customer-verification service returns error
    And user with status "Verified"
    And provider mocked request customer-verification failure
    And deposit request body
    When send deposit request
    Then deposit response statusCode=200, code=111, message="Provider Error"

  @SNGPAY-1643
  Scenario: Deposit when account is not verified from provider
    And user with status "Verified"
    And provider mocked request customer-verification returns response with verificationLevel="9"
    And deposit request body
    When send deposit request
    Then deposit response statusCode=200, code=111, message="Provider Error"

  @SNGPAY-1644
  Scenario: Deposit when rule engine actions equals pending
    And user with status "Verified"
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And deposit request body with action pending
    When send deposit request
    Then deposit response statusCode=200, code=99, message="Deposit doesn't support 'PENDING' action"

  @SNGPAY-1645
  Scenario: Deposit when rule engine actions equals reject
    And user with status "Verified"
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And deposit request body with action reject
    When send deposit request
    Then deposit response statusCode=200, code=99, message="'REJECT' action is not allowed here"

  @SNGPAY-1646
   Scenario: Deposit when currency is invalid
    And user with status "Verified"
    And deposit request body with unsupported currency
    When send deposit request
    Then deposit response statusCode=200, code=99, message="Invalid Currency"

  @SNGPAY-1647
   Scenario: Deposit when callback status Pending
    And user with status "Verified"
    And deposit request body
    When send deposit request
    And provider mocked request customer-verification returns response with verificationLevel="10"
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given ruleEngine validation passed
    And deposit callback request params with status Pending
    When send deposit callback request
    Then deposit callback response statusCode=202, code=111, message="Unexpected vendor transaction state: Transaction is still processing in vendor system"
    And check deposit response data parameters
    And check deposit sis transaction details in db, status="ProviderPending", fee="false"

  @SNGPAY-1648
   Scenario: Deposit when callback status Scheduled
    And user with status "Verified"
    And deposit request body
    When send deposit request
    And provider mocked request customer-verification returns response with verificationLevel="10"
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given ruleEngine validation passed
    And deposit callback request params with status Scheduled
    When send deposit callback request
    Then deposit callback response statusCode=202, code=111, message="Transaction failed in vendor system"
    And check deposit response data parameters
    And check deposit sis transaction details in db, status="FailedFromProvider", fee="false"

  @SNGPAY-1649
   Scenario: Deposit when callback status is unknown
    And user with status "Verified"
    And deposit request body
    When send deposit request
    And provider mocked request customer-verification returns response with verificationLevel="10"
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given ruleEngine validation passed
    And deposit callback request params with status is unknown
    When send deposit callback request
    Then deposit callback response statusCode=202, code=111, message="Transaction failed in vendor system"
    And check deposit response data parameters
    And check deposit sis transaction details in db, status="FailedFromProvider", fee="false"

  @SNGPAY-1650
   Scenario: Deposit callback with incorrect transaction id
    And user with status "Verified"
    And deposit request body
    When send deposit request
    And provider mocked request customer-verification returns response with verificationLevel="10"
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given ruleEngine validation passed
    And deposit callback request params with incorrect transaction id
    When send deposit callback request
    Then deposit callback response statusCode=202, code=156, message="Transaction not found"

  @SNGPAY-1651
  Scenario: Deposit when deposit and callback requests has different amount value
    And user with status "Verified"
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And ruleEngine validation passed
    And deposit request body different amount in callback
    When send deposit request
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given deposit callback request params with different amount in deposit
    When send deposit callback request
    Then deposit callback response statusCode=202, code=99, message="Invalid amount"
    And check deposit sis transaction details in db, status="ProviderPending", fee="false"

  @SNGPAY-1652
  Scenario: Deposit when deposit and callback requests has different currency value
    And user with status "Verified"
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And ruleEngine validation passed
    And deposit request body different currency in callback
    When send deposit request
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given deposit callback request params with different currency in deposit
    When send deposit callback request
    Then deposit callback response statusCode=202, code=99, message="Invalid currency"
    And check deposit sis transaction details in db, status="ProviderPending", fee="false"