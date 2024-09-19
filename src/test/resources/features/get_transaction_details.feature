Feature: Get Transaction Details

  @Smoke
  Scenario: Get deposit transaction details success
    # implement deposit full scenario here for create deposit transaction in system
    Given get transaction details request body
    When send get transaction request

  @Smoke
  Scenario: Get withdraw transaction details success
    # implement withdraw full scenario here for create deposit transaction in system
    Given get transaction details request body
    When send get transaction request