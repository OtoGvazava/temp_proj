Feature: With provider real service

  Background:
    And user with status "Verified"

  Scenario: Success deposit
    # implement success deposit flow without any mocking step

  Scenario: Success withdraw
    # implement success withdraw flow without any mocking step

  Scenario Outline: Success Job
    # implement success pending deposit flow without any mocking step
    Given sis withdraw transaction with status "<SisStatus>", started="false"
    And sis withdraw transaction with status "<SisStatus>", started="true"
    And core withdraw transaction with status "Success"
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