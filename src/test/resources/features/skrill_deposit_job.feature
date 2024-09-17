Feature: Deposit Job

  Background:
    Given consul properties
    And user id
    And provider id
    And service id
    And user with status "Verified"
    And empty started transactions table for the user

  Scenario Outline: Process deposit transactions with different statuses in Core/Persistence/Provider
    And provider mocked request customer-verification returns response with verificationLevel="10"
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
    Given sis deposit transaction with status "<SisStatusBefore>", started="false"
    And the deposit transaction exists in started_transactions table
    And sis deposit transaction with status "<SisStatusBefore>", started="true"
    And provider mocked request query.pl transfer status "<ProviderStatus>"
    And core deposit transaction with status "<CoreStatusBefore>"
    When send deposit job request
    Then deposit job response statusCode=200, code=10, message="Success"
    And check deposit core transaction details in db, status="<CoreStatusAfter>", fee="false"
    And check deposit sis transaction details in db, status="<SisStatusAfter>", fee="false"

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

      | Pending        | Started                           | Success          | Started                           | Success         |
      | Pending        | Started                           | Pending          | Started                           | Pending         |
      | Pending        | Started                           | Rejected         | Started                           | Rejected        |
      | Pending        | Started                           | Canceled         | Started                           | Canceled        |
      | Pending        | Started                           | Approved         | Started                           | Approved        |

      | Pending        | AmountWithdrawFromProviderAccount | Success          | AmountWithdrawFromProviderAccount | Success         |
      | Pending        | AmountWithdrawFromProviderAccount | Pending          | AmountWithdrawFromProviderAccount | Pending         |
      | Pending        | AmountWithdrawFromProviderAccount | Rejected         | AmountWithdrawFromProviderAccount | Rejected        |
      | Pending        | AmountWithdrawFromProviderAccount | Canceled         | AmountWithdrawFromProviderAccount | Canceled        |
      | Pending        | AmountWithdrawFromProviderAccount | Approved         | AmountWithdrawFromProviderAccount | Approved        |

      | Pending        | StartRollback                     | Success          | StartRollback                     | Success         |
      | Pending        | StartRollback                     | Pending          | StartRollback                     | Pending         |
      | Pending        | StartRollback                     | Rejected         | StartRollback                     | Rejected        |
      | Pending        | StartRollback                     | Canceled         | StartRollback                     | Canceled        |
      | Pending        | StartRollback                     | Approved         | StartRollback                     | Approved        |

      | Pending        | ProviderPending                   | Success          | ProviderPending                   | Success         |
      | Pending        | ProviderPending                   | Pending          | ProviderPending                   | Pending         |
      | Pending        | ProviderPending                   | Rejected         | ProviderPending                   | Rejected        |
      | Pending        | ProviderPending                   | Canceled         | ProviderPending                   | Canceled        |
      | Pending        | ProviderPending                   | Approved         | ProviderPending                   | Approved        |

      | Pending        | Pending                           | Success          | Pending                           | Success         |
      | Pending        | Pending                           | Pending          | Pending                           | Pending         |
      | Pending        | Pending                           | Rejected         | StartRollback                     | Rejected        |
      | Pending        | Pending                           | Canceled         | StartRollback                     | Canceled        |
      | Pending        | Pending                           | Approved         | Pending                           | Approved        |

      | Scheduled      | Started                           | Success          | Started                           | Success         |
      | Scheduled      | Started                           | Pending          | Started                           | Pending         |
      | Scheduled      | Started                           | Rejected         | Started                           | Rejected        |
      | Scheduled      | Started                           | Canceled         | Started                           | Canceled        |
      | Scheduled      | Started                           | Approved         | Started                           | Approved        |

      | Scheduled      | AmountWithdrawFromProviderAccount | Success          | AmountWithdrawFromProviderAccount | Success         |
      | Scheduled      | AmountWithdrawFromProviderAccount | Pending          | AmountWithdrawFromProviderAccount | Pending         |
      | Scheduled      | AmountWithdrawFromProviderAccount | Rejected         | AmountWithdrawFromProviderAccount | Rejected        |
      | Scheduled      | AmountWithdrawFromProviderAccount | Canceled         | AmountWithdrawFromProviderAccount | Canceled        |
      | Scheduled      | AmountWithdrawFromProviderAccount | Approved         | AmountWithdrawFromProviderAccount | Approved        |

      | Scheduled      | StartRollback                     | Success          | StartRollback                     | Success         |
      | Scheduled      | StartRollback                     | Pending          | StartRollback                     | Pending         |
      | Scheduled      | StartRollback                     | Rejected         | StartRollback                     | Rejected        |
      | Scheduled      | StartRollback                     | Canceled         | StartRollback                     | Canceled        |
      | Scheduled      | StartRollback                     | Approved         | StartRollback                     | Approved        |

      | Scheduled      | ProviderPending                   | Success          | ProviderPending                   | Success         |
      | Scheduled      | ProviderPending                   | Pending          | ProviderPending                   | Pending         |
      | Scheduled      | ProviderPending                   | Rejected         | ProviderPending                   | Rejected        |
      | Scheduled      | ProviderPending                   | Canceled         | ProviderPending                   | Canceled        |
      | Scheduled      | ProviderPending                   | Approved         | ProviderPending                   | Approved        |

      | Scheduled      | Pending                           | Success          | Pending                           | Success         |
      | Scheduled      | Pending                           | Pending          | Pending                           | Pending         |
      | Scheduled      | Pending                           | Rejected         | StartRollback                     | Rejected        |
      | Scheduled      | Pending                           | Canceled         | StartRollback                     | Canceled        |
      | Scheduled      | Pending                           | Approved         | Pending                           | Approved        |

  Scenario Outline: Process deposit transactions when in provider not found
    And provider mocked request customer-verification returns response with verificationLevel="10"
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
    Given sis deposit transaction with status "<SisStatusBefore>", started="false"
    And the deposit transaction exists in started_transactions table
    And sis deposit transaction with status "<SisStatusBefore>", started="true"
    And provider mocked request query.pl transfer status not found
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
    And provider mocked request customer-verification returns response with verificationLevel="10"
    And ruleEngine validation passed
    And deposit request body
    When send deposit request
    Then deposit response statusCode=200, code=10, message="Success"
    And check deposit response data parameters
    And check deposit sis transaction details in db, status="ProviderPending", fee="true"
    Given sis deposit transaction with status "<SisStatusBefore>", started="false"
    And provider mocked request query.pl transfer status "<ProviderStatus>"
    When send deposit job request
    Then deposit job response statusCode=200, code=10, message="Success"
    And check deposit sis transaction details in db, status="<SisStatusAfter>", fee="false"

    Examples:
      | ProviderStatus | SisStatusBefore   | SisStatusAfter |
      | Success        | Started           | StartRollback  |
      | Success        | Started           | ProviderPending  |
      | Success        | Started           | Pending  |
      | Success        | Started           | AmountWithdrawFromProviderAccount  |
      | Success        | Started           | Started  |