Feature: Withdraw Job
  Background:
    Given empty started transactions table for the user

  @Smoke
  Scenario Outline: Process transaction when Core=Success, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Processed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    And provider mocked request query.pl transfer status success
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="true"
    And check withdraw sis transaction details in db, status="Finished", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Success, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Failed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    And provider mocked request query.pl transfer status failed
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Rollback", fee="true"
    And check withdraw sis transaction details in db, status="Rollback", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Success, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Pending
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    And provider mocked request query.pl transfer status pending
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="true"
    And check withdraw sis transaction details in db, status="ProviderPending", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | Pending                           |
      | ProviderPending                   |

  Scenario: Process transaction when Core=Success, Sis=AmountWithdrawnFromCoreAccount, Provider=Pending
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "AmountWithdrawnFromCoreAccount", started="false"
    And sis withdraw transaction with status "AmountWithdrawnFromCoreAccount", started="true"
    And core withdraw transaction with status "Success"
    And provider mocked request query.pl transfer status pending
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="true"
    And check withdraw sis transaction details in db, status="AmountWithdrawnFromCoreAccount", fee="true"

  Scenario Outline: Process transaction when Core=Success, Sis=Started/AmountWithdrawnFromCoreAccount/Pending, Provider=Unknown
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    And provider mocked request query.pl transfer returns empty response
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="true"
    And check withdraw sis transaction details in db, status="<SisStatus>", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Success, Sis=Started/AmountWithdrawnFromCoreAccount/Pending, Provider=Timeout
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    And provider mocked request query.pl transfer timeout
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="true"
    And check withdraw sis transaction details in db, status="<SisStatus>", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Success, Sis=AmountWithdrawnFromCoreAccount, Provider=Scheduled
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    And provider mocked request query.pl transfer status scheduled
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="true"
    And check withdraw sis transaction details in db, status="<SisStatus>", fee="true"

    Examples:
      | SisStatus                         |
      | AmountWithdrawnFromCoreAccount    |

  Scenario Outline: Process transaction when Core=Success, Sis=Started/Pending/ProviderPending, Provider=Scheduled
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    And provider mocked request query.pl transfer status scheduled
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="true"
    And check withdraw sis transaction details in db, status="ProviderPending", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | Pending                           |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Pending, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Processed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Pending"
    And provider mocked request query.pl transfer status success
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="<SisStatus>", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Pending, Sis=AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Failed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Pending"
    And provider mocked request query.pl transfer status failed
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="<SisStatus>", fee="true"

    Examples:
      | SisStatus                         |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Approved, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Processed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Approved"
    And provider mocked request query.pl transfer status success
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Approved", fee="true"
    And check withdraw sis transaction details in db, status="Finished", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Approved, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Processed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Approved"
    And provider mocked request query.pl transfer status success
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Approved", fee="true"
    And check withdraw sis transaction details in db, status="Finished", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Approved, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Failed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Approved"
    And provider mocked request query.pl transfer status failed
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Rollback", fee="true"
    And check withdraw sis transaction details in db, status="Rollback", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Rejected, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Processed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Rejected"
    And provider mocked request query.pl transfer status success
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Rejected", fee="true"
    And check withdraw sis transaction details in db, status="<SisStatus>", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Rejected, Sis=Started/Pending, Provider=Failed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Rejected"
    And provider mocked request query.pl transfer status failed
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Rejected", fee="true"
    And check withdraw sis transaction details in db, status="Rejected", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | Pending                           |

  Scenario Outline: Process transaction when Core=Rejected, Sis=AmountWithdrawnFromCoreAccount/ProviderPending, Provider=Failed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Rejected"
    And provider mocked request query.pl transfer status failed
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Rejected", fee="true"
    And check withdraw sis transaction details in db, status="FailedInCore", fee="true"

    Examples:
      | SisStatus                         |
      | AmountWithdrawnFromCoreAccount    |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Rejected, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Pending
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Rejected"
    And provider mocked request query.pl transfer status pending
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Rejected", fee="true"
    And check withdraw sis transaction details in db, status="<SisStatus>", fee="true"

    Examples:
      | SisStatus                         |
      | AmountWithdrawnFromCoreAccount    |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Rejected, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Pending
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Rejected"
    And provider mocked request query.pl transfer status pending
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Rejected", fee="true"
    And check withdraw sis transaction details in db, status="Rejected", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | Pending                           |

  Scenario Outline: Process transaction when Core=Canceled, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Processed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Canceled"
    And provider mocked request query.pl transfer status success
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Canceled", fee="true"
    And check withdraw sis transaction details in db, status="<SisStatus>", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Canceled, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Failed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Canceled"
    And provider mocked request query.pl transfer status failed
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Canceled", fee="true"
    And check withdraw sis transaction details in db, status="FailedInCore", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | Pending                           |

  Scenario Outline: Process transaction when Core=Canceled, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Failed
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Canceled"
    And provider mocked request query.pl transfer status failed
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Canceled", fee="true"
    And check withdraw sis transaction details in db, status="FailedInCore", fee="true"

    Examples:
      | SisStatus                         |
      | AmountWithdrawnFromCoreAccount    |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Canceled, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Pending
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Canceled"
    And provider mocked request query.pl transfer status pending
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Canceled", fee="true"
    And check withdraw sis transaction details in db, status="FailedInCore", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | Pending                           |

  Scenario Outline: Process transaction when Core=Canceled, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Pending
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Canceled"
    And provider mocked request query.pl transfer status pending
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Canceled", fee="true"
    And check withdraw sis transaction details in db, status="<SisStatus>", fee="true"

    Examples:
      | SisStatus                         |
      | AmountWithdrawnFromCoreAccount    |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Success, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=NotFound
    Given provider mocked request customer-verification returns response with verificationLevel="10"
    And provider mocked request pay.pl prepare success
    And provider mocked request pay.pl transfer success
    And withdraw request body with action pending
    When send withdraw request
    Then withdraw response statusCode=200, code=182, message="TransactionStatusPending"
    And check withdraw core transaction details in db, status="Pending", fee="true"
    And check withdraw sis transaction details in db, status="Pending", fee="true"
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    And provider mocked request query.pl transfer status not found
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Rollback", fee="true"
    And check withdraw sis transaction details in db, status="Rollback", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | AmountWithdrawnFromCoreAccount    |
      | Pending                           |
      | ProviderPending                   |