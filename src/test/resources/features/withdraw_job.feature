Feature: Withdraw Job
  Background:
    Given empty started transactions table for the user

  @Smoke
  Scenario Outline: Process transaction when Core=Success, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Processed
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    # add step to mock provider request as returns success status
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    # add step to mock provider request as returns failed status
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    # add step to mock provider request as returns pending status
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "AmountWithdrawnFromCoreAccount", started="false"
    And sis withdraw transaction with status "AmountWithdrawnFromCoreAccount", started="true"
    And core withdraw transaction with status "Success"
    # add step to mock provider request as returns pending status
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="true"
    And check withdraw sis transaction details in db, status="AmountWithdrawnFromCoreAccount", fee="true"

  Scenario Outline: Process transaction when Core=Success, Sis=Started/AmountWithdrawnFromCoreAccount/Pending, Provider=Unknown
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    # add step to mock provider request as returns empty response
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    # add step to mock provider request as timeout
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    # add step to mock provider request as returns scheduled
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Success", fee="true"
    And check withdraw sis transaction details in db, status="<SisStatus>", fee="true"

    Examples:
      | SisStatus                         |
      | AmountWithdrawnFromCoreAccount    |

  Scenario Outline: Process transaction when Core=Success, Sis=Started/Pending/ProviderPending, Provider=Scheduled
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    # add step to mock provider request as returns scheduled
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Pending"
    # add step to mock provider request as returns failed
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Pending"
    # add step to mock provider request as returns failed
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Approved"
    # add step to mock provider request as returns success
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Approved"
    # add step to mock provider request as returns success
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Approved"
    # add step to mock provider request as returns failed
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Rejected"
    # add step to mock provider request as returns success
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Rejected"
    # add step to mock provider request as returns failed
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Rejected", fee="true"
    And check withdraw sis transaction details in db, status="Rejected", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | Pending                           |

  Scenario Outline: Process transaction when Core=Rejected, Sis=AmountWithdrawnFromCoreAccount/ProviderPending, Provider=Failed
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Rejected"
    # add step to mock provider request as returns failed
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Rejected", fee="true"
    And check withdraw sis transaction details in db, status="FailedInCore", fee="true"

    Examples:
      | SisStatus                         |
      | AmountWithdrawnFromCoreAccount    |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Rejected, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Pending
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Rejected"
    # add step to mock provider request as returns pending
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Rejected", fee="true"
    And check withdraw sis transaction details in db, status="<SisStatus>", fee="true"

    Examples:
      | SisStatus                         |
      | AmountWithdrawnFromCoreAccount    |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Rejected, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Pending
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Rejected"
    # add step to mock provider request as returns success
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Rejected", fee="true"
    And check withdraw sis transaction details in db, status="Rejected", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | Pending                           |

  Scenario Outline: Process transaction when Core=Canceled, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Processed
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Canceled"
    # add step to mock provider request as returns success
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
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Canceled"
    # add step to mock provider request as returns failed
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Canceled", fee="true"
    And check withdraw sis transaction details in db, status="FailedInCore", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | Pending                           |

  Scenario Outline: Process transaction when Core=Canceled, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Failed
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Canceled"
    # add step to mock provider request as returns failed
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Canceled", fee="true"
    And check withdraw sis transaction details in db, status="FailedInCore", fee="true"

    Examples:
      | SisStatus                         |
      | AmountWithdrawnFromCoreAccount    |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Canceled, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Pending
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Canceled"
    # add step to mock provider request as returns pending
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Canceled", fee="true"
    And check withdraw sis transaction details in db, status="FailedInCore", fee="true"

    Examples:
      | SisStatus                         |
      | Started                           |
      | Pending                           |

  Scenario Outline: Process transaction when Core=Canceled, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=Pending
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Canceled"
    # add step to mock provider request as returns pending
    When send withdraw job request
    Then withdraw job response statusCode=200, code=10, message="Success"
    And check withdraw core transaction details in db, status="Canceled", fee="true"
    And check withdraw sis transaction details in db, status="<SisStatus>", fee="true"

    Examples:
      | SisStatus                         |
      | AmountWithdrawnFromCoreAccount    |
      | ProviderPending                   |

  Scenario Outline: Process transaction when Core=Success, Sis=Started/AmountWithdrawnFromCoreAccount/Pending/ProviderPending, Provider=NotFound
    # implement pending withdraw full scenario here for create deposit transaction in system
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
    # add step to mock provider request as not found request
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