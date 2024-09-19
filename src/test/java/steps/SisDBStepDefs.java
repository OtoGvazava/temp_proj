package steps;

import configuration.Configuration;
import ge.singular.payment.data.SisTransactionStatus;
import ge.singular.payment.data.SisTransactionType;
import ge.singular.payment.db.SisPaymentsDB;
import ge.singular.payment.db.SisTransactionDto;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import lombok.SneakyThrows;

public class SisDBStepDefs extends BaseSteps {
    private final SisPaymentsDB sisPaymentsDB;

    public SisDBStepDefs() {
        sisPaymentsDB = new SisPaymentsDB(Configuration.commonConfig.getDb().getRuleEngine().getHost() + ":" + Configuration.commonConfig.getDb().getRuleEngine().getPort(),
                Configuration.commonConfig.getDb().getRuleEngine().getUsername(),
                Configuration.commonConfig.getDb().getRuleEngine().getPassword());
    }

    @Override
    public void reset() {
    }

    @Then("check withdraw sis transaction details in db, status={string}, fee={string}")
    public void checkWithdrawSisTransactionDetails(String status, String fee) {
        var expectedStatus = SisTransactionStatus.findByName(status);
        sisPaymentsDB.assertSisTransaction(
                false,
                WithdrawRequestStepDefs.request.getResponseBody().getData().getTransactionId(),
                SisTransactionDto.builder()
                        .amount(WithdrawRequestStepDefs.requestBody.getAmount())
                        .fee(Boolean.parseBoolean(fee) ? WithdrawRequestStepDefs.requestBody.getFee() : 0)
                        .status(expectedStatus.getId())
                        .transactionType(SisTransactionType.CoreToProvider.name())
                        .userID(WithdrawRequestStepDefs.requestBody.getUserId())
                        .paymentAccount(WithdrawRequestStepDefs.requestBody.getAccount())
                        .currency(WithdrawRequestStepDefs.requestBody.getCurrency())
                        .serviceID(WithdrawRequestStepDefs.requestBody.getServiceId())
                        .providerLabel(Configuration.integrationConfig.getProviderLabel())
                        .build()
        );
    }

    @SneakyThrows
    @Then("check deposit sis transaction details in db, status={string}, fee={string}")
    public void checkDepositSisTransactionDetails(String status, String fee) {
        var expectedStatus = SisTransactionStatus.findByName(status);

        var paymentAccount = "";
        if (DepositRequestStepDefs.requestBody.getAccount() != null) {
            paymentAccount = DepositRequestStepDefs.requestBody.getAccount();
        } else paymentAccount = null;

        sisPaymentsDB.assertSisTransaction(
                false,
                DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId(),
                SisTransactionDto.builder()
                        .amount(DepositRequestStepDefs.requestBody.getAmount())
                        .fee(Boolean.parseBoolean(fee) ? DepositRequestStepDefs.requestBody.getFee() : 0)
                        .status(expectedStatus.getId())
                        .transactionType(SisTransactionType.ProviderToCore.name())
                        .userID(DepositRequestStepDefs.requestBody.getUserId())
                        .paymentAccount(paymentAccount)
                        .currency(DepositRequestStepDefs.requestBody.getCurrency())
                        .serviceID(DepositRequestStepDefs.requestBody.getServiceId())
                        .providerLabel(Configuration.integrationConfig.getProviderLabel())
                        .build()
        );
    }

    @Given("sis withdraw transaction with status {string}, started={string}")
    public void changeWithdrawTransactionStatus(String statusStr, String startedStr) {
        var futureStatus = SisTransactionStatus.findByName(statusStr);
        var started = Boolean.parseBoolean(startedStr);
        sisPaymentsDB.updateTransactionStatus(started, futureStatus.getId(),
                WithdrawRequestStepDefs.request.getResponseBody().getData().getTransactionId());
    }

    @Given("sis deposit transaction with status {string}, started={string}")
    public void changeDepositTransactionStatus(String statusStr, String startedStr) {
        var futureStatus = SisTransactionStatus.findByName(statusStr);
        var started = Boolean.parseBoolean(startedStr);
        sisPaymentsDB.updateTransactionStatus(started, futureStatus.getId(),
                DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId());
    }

    @And("the deposit transaction exists in started_transactions table")
    public void insertStartedTransactionFromTransaction() {
        this.sisPaymentsDB.insertTransactionStartedFromTransactions(DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId());
    }

    @Given("empty started transactions table for the user")
    public void deleteStartedTransactions() {
        this.sisPaymentsDB.deleteTransactionsBy(Configuration.integrationConfig.getUserId());
    }
}