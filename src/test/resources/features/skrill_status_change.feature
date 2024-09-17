Feature: Status Change

  Background:
    Given user with status "Verified"

  Scenario: Status Change when transaction is already processed
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action approve
    When send withdraw request
    Then withdraw response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="false"
    And check withdraw sis transaction details in db, status="Finished", fee="false"
    When send get core user transactions request for withdraw
    Then core user transaction response status code equals 10
    Given status change request body
    When send status change request
    Then status change response statusCode=200, code=10, message="Already processed"

  Scenario: Status Change when transaction pending
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    When send get core user transactions request for withdraw
    Then core user transaction response status code equals 10
    Given status change request body
    When send status change request
    Then status change response statusCode=200, code=10, message="Pending: skipped"

  @Smoke
  Scenario: Success status change when withdraw approved from BO
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    When send get core user transactions request for withdraw
    Then core user transaction response status code equals 10
    When send core transaction status change request as approved
    Then result code of core transaction status change request equals 10
    Given status change request body
    When send status change request
    Then status change response statusCode=200, code=10, message="Success"
    And check withdraw sis transaction details in db, status="Finished", fee="true"
    And check withdraw core transaction details in db, status="Approved", fee="true"

  Scenario: Success status change when withdraw approved from BO when provider fail
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    When send get core user transactions request for withdraw
    Then core user transaction response status code equals 10
    When send core transaction status change request as approved
    Then result code of core transaction status change request equals 10
    Given status change request body
    And provider mocked request pay.pl transfer error
    When send status change request
    Then status change response statusCode=200, code=111, message="Generic Failure"
    And check withdraw sis transaction details in db, status="FailedFromProvider", fee="true"
    And check withdraw core transaction details in db, status="Rollback", fee="true"

  Scenario: Success status change when withdraw approved from BO when provider unknown
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    When send get core user transactions request for withdraw
    Then core user transaction response status code equals 10
    When send core transaction status change request as approved
    Then result code of core transaction status change request equals 10
    Given status change request body
    And provider mocked request pay.pl transfer empty response
    When send status change request
    Then status change response statusCode=200, code=10, message="Success"
    And check withdraw sis transaction details in db, status="AmountWithdrawnFromCoreAccount", fee="true"
    And check withdraw core transaction details in db, status="Approved", fee="true"

  @Smoke
  Scenario: Success status change when withdraw rejected from BO
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    When send get core user transactions request for withdraw
    Then core user transaction response status code equals 10
    When send core transaction status change request as rejected
    Then result code of core transaction status change request equals 10
    Given status change request body
    When send status change request
    Then status change response statusCode=200, code=10, message="Transaction Reject successfully processed"
    And check withdraw sis transaction details in db, status="Rejected", fee="true"
    And check withdraw core transaction details in db, status="Rejected", fee="true"