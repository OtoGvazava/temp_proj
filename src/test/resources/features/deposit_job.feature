Feature: Deposit Job

  Background:
    And user with status "Verified"
    And empty started transactions table for the user

  Scenario Outline: Process deposit transactions with different statuses in Core/Persistence/Provider
    # implement deposit full scenario here for create deposit transaction in system
    Given sis deposit transaction with status "<SisStatusBefore>", started="false"
    And the deposit transaction exists in started_transactions table
    And sis deposit transaction with status "<SisStatusBefore>", started="true"
    And core deposit transaction with status "<CoreStatusBefore>"
    # add step to mock provider request to return status with value 'ProviderStatus'
    When send deposit job request
    Then deposit job response statusCode=200, code=10, message="Success"
    And check deposit core transaction details in db, status="<CoreStatusAfter>", fee="false"
    And check deposit sis transaction details in db, status="<SisStatusAfter>", fee="false"

    # ProviderStatus is status from provider side this variable should be used to mock provider request and return such status

    Examples:
      | ProviderStatus | SisStatusBefore                   | CoreStatusBefore | SisStatusAfter                    | CoreStatusAfter |
      | Success        | Started                           | Success          | Finished                          | Success         |
      | Success        | Started                           | Pending          | Started                           | Pending         |
      | Success        | Started                           | Rejected         | StartRollback                     | Rejected        |
      | Success        | Started                           | Canceled         | StartRollback                     | Canceled        |
      | Success        | Started                           | Approved         | Finished                          | Approved        |

      | Success        | AmountWithdrawFromProviderAccount | Success          | Finished                          | Success         |
      | Success        | AmountWithdrawFromProviderAccount | Pending          | Pending                           | Pending         |
      | Success        | AmountWithdrawFromProviderAccount | Rejected         | StartRollback                     | Rejected        |
      | Success        | AmountWithdrawFromProviderAccount | Canceled         | StartRollback                     | Canceled        |
      | Success        | AmountWithdrawFromProviderAccount | Approved         | Finished                          | Approved         |

      | Success        | StartRollback                     | Success          | StartRollback                     | Success         |
      | Success        | StartRollback                     | Pending          | StartRollback                     | Pending         |
      | Success        | StartRollback                     | Rejected         | StartRollback                     | Rejected        |
      | Success        | StartRollback                     | Canceled         | StartRollback                     | Canceled        |
      | Success        | StartRollback                     | Approved         | StartRollback                     | Approved        |

      | Success        | ProviderPending                   | Success          | Finished                          | Success         |
      | Success        | ProviderPending                   | Pending          | ProviderPending                   | Pending         |
      | Success        | ProviderPending                   | Rejected         | StartRollback                     | Rejected        |
      | Success        | ProviderPending                   | Canceled         | StartRollback                     | Canceled        |
      | Success        | ProviderPending                   | Approved         | Finished                          | Approved        |

      | Success        | Pending                           | Success          | Finished                          | Success         |
      | Success        | Pending                           | Pending          | Pending                           | Pending         |
      | Success        | Pending                           | Rejected         | StartRollback                     | Rejected        |
      | Success        | Pending                           | Canceled         | StartRollback                     | Canceled        |
      | Success        | Pending                           | Approved         | Finished                          | Approved        |

      # ProviderStatus (Success/Failed) is status from provider side this variable should be used to mock provider request and return such status

      | Failed         | Started                           | Success          | Started                           | Success         |
      | Failed         | Started                           | Pending          | Started                           | Pending         |
      | Failed         | Started                           | Rejected         | Started                           | Rejected        |
      | Failed         | Started                           | Canceled         | Started                           | Canceled        |
      | Failed         | Started                           | Approved         | Started                           | Approved        |

      | Failed         | AmountWithdrawFromProviderAccount | Success          | AmountWithdrawFromProviderAccount | Success         |
      | Failed         | AmountWithdrawFromProviderAccount | Pending          | AmountWithdrawFromProviderAccount | Pending         |
      | Failed         | AmountWithdrawFromProviderAccount | Rejected         | AmountWithdrawFromProviderAccount | Rejected        |
      | Failed         | AmountWithdrawFromProviderAccount | Canceled         | AmountWithdrawFromProviderAccount | Canceled        |
      | Failed         | AmountWithdrawFromProviderAccount | Approved         | AmountWithdrawFromProviderAccount | Approved        |

      | Failed         | StartRollback                     | Success          | StartRollback                     | Success         |
      | Failed         | StartRollback                     | Pending          | StartRollback                     | Pending         |
      | Failed         | StartRollback                     | Rejected         | StartRollback                     | Rejected        |
      | Failed         | StartRollback                     | Canceled         | StartRollback                     | Canceled        |
      | Failed         | StartRollback                     | Approved         | StartRollback                     | Approved        |

      | Failed         | ProviderPending                   | Success          | ProviderPending                   | Success         |
      | Failed         | ProviderPending                   | Pending          | Pending                           | Pending         |
      | Failed         | ProviderPending                   | Rejected         | ProviderPending                   | Rejected        |
      | Failed         | ProviderPending                   | Canceled         | ProviderPending                   | Canceled        |
      | Failed         | ProviderPending                   | Approved         | ProviderPending                   | Approved        |

      | Failed         | Pending                           | Success          | Pending                           | Success         |
      | Failed         | Pending                           | Pending          | Pending                           | Pending         |
      | Failed         | Pending                           | Rejected         | StartRollback                     | Rejected        |
      | Failed         | Pending                           | Canceled         | StartRollback                     | Canceled        |
      | Failed         | Pending                           | Approved         | StartRollback                     | Approved        |

  Scenario Outline: Process deposit transactions when in provider not found
    # implement deposit full scenario here for create deposit transaction in system
    Given sis deposit transaction with status "<SisStatusBefore>", started="false"
    And the deposit transaction exists in started_transactions table
    And sis deposit transaction with status "<SisStatusBefore>", started="true"
    # add step to mock provider request as not found request
    And core deposit transaction with status "<CoreStatusBefore>"
    When send deposit job request
    Then deposit job response statusCode=200, code=10, message="Success"
    And check deposit core transaction details in db, status="<CoreStatusAfter>", fee="false"
    And check deposit sis transaction details in db, status="<SisStatusAfter>", fee="false"

    Examples:
      | SisStatusBefore                   | CoreStatusBefore | SisStatusAfter                    | CoreStatusAfter |
      | Started                           | Success          | Started                           | Success         |
      | AmountWithdrawFromProviderAccount | Success          | AmountWithdrawFromProviderAccount | Success         |
      | StartRollback                     | Success          | StartRollback                     | Success         |
      | ProviderPending                   | Success          | ProviderPending                   | Success         |
      | Pending                           | Success          | Pending                           | Success         |

  Scenario Outline: Process deposit transactions when in core not found
    # implement deposit scenario (not include CALLBACK) here for create deposit transaction in system
    Given sis deposit transaction with status "<SisStatusBefore>", started="false"
    # add step to mock provider request to return status with value 'ProviderStatus'
    When send deposit job request
    Then deposit job response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="<SisStatusAfter>", fee="false"

    Examples:
      | ProviderStatus | SisStatusBefore   | SisStatusAfter  |
      | Success        | Started           | StartRollback   |
      | Success        | Started           | ProviderPending |
      | Success        | Started           | Pending         |
      | Success        | Started           | AmountWithdrawFromProviderAccount  |
      | Success        | Started           | Started         |