package steps;

import configuration.Configuration;
import ge.singular.casinocore.data.CoreTransactionStatus;
import ge.singular.casinocore.data.UserStatus;
import ge.singular.casinocore.db.CoreDB;
import ge.singular.casinocore.db.CoreTransactionDto;
import ge.singular.payment.data.RuleEngineAction;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;

public class CoreDBStepDefs extends BaseStepDefs {
    private final CoreDB coreDB;

    public CoreDBStepDefs() {
        coreDB = new CoreDB(Configuration.commonConfig.getDb().getCore().getHost() + ":" + Configuration.commonConfig.getDb().getCore().getPort(),
                Configuration.commonConfig.getDb().getCore().getUsername(), Configuration.commonConfig.getDb().getCore().getPassword());
    }


    @Override
    public void reset() {
    }

    @Given("payment account isVerified={string}")
    public void updatePaymentAccountIsVerified(String isVerifiedStr) {
        var isVerified = Boolean.parseBoolean(isVerifiedStr);
        this.coreDB.updatePaymentAccountIsVerifiedBy(isVerified, 0);

        throw new RuntimeException("You should change above id value instead 0 and remove this code line!");
    }

    @Given("user with status {string}")
    public void setUserStatus(String statusName) {
        UserStatus status = UserStatus.findByName(statusName);
        coreDB.updateUserStatus(status.getId(), Configuration.integrationConfig.getUserId());
    }

    @Then("check withdraw core transaction details in db, status={string}, fee={string}")
    public void checkWithdrawSisTransactionDetails(String status, String fee) {
        var expectedStatus = CoreTransactionStatus.findByName(status);
        coreDB.assertCoreTransactionDetails(
                Configuration.integrationConfig.getUserId(), 
                WithdrawRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString(),
                CoreTransactionDto.builder()
                        .transactionAmount(-Double.valueOf(WithdrawRequestStepDefs.requestBody.getAmount()))
                        .txFeeAmount(Boolean.parseBoolean(fee) ? (double) WithdrawRequestStepDefs.requestBody.getFee() : 0)
                        .transactionStatus(expectedStatus.getId())
                        .userID((long) WithdrawRequestStepDefs.requestBody.getUserId())
                        .providerServiceID(WithdrawRequestStepDefs.requestBody.getServiceId()).build()
        );
    }

    @Then("check deposit core transaction details in db, status={string}, fee={string}")
    public void checkDepositSisTransactionDetails(String status, String fee) {
        var expectedStatus = CoreTransactionStatus.findByName(status);
        coreDB.assertCoreTransactionDetails(
                Configuration.integrationConfig.getUserId(),
                DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString(),
                CoreTransactionDto.builder()
                        .transactionAmount(
                                DepositRequestStepDefs.requestBody.getActions().contains(RuleEngineAction.CHARGE.getId())
                                        ? Double.valueOf(DepositRequestStepDefs.requestBody.getAmount() - DepositRequestStepDefs.requestBody.getFee())
                                        : Double.valueOf(DepositRequestStepDefs.requestBody.getAmount()))
                        .txFeeAmount(Boolean.parseBoolean(fee) ? (double) DepositRequestStepDefs.requestBody.getFee() : 0)
                        .transactionStatus(expectedStatus.getId())
                        .userID((long) DepositRequestStepDefs.requestBody.getUserId())
                        .providerServiceID(DepositRequestStepDefs.requestBody.getServiceId()).build()
        );
    }

    @Given("core withdraw transaction with status {string}")
    public void changeWithdrawTransactionStatus(String statusStr) {
        var futureStatus = CoreTransactionStatus.findByName(statusStr);
        coreDB.updateTransactionStatus(futureStatus.getId(), WithdrawRequestStepDefs.request.getResponseBody().getData().getTransactionId(), Configuration.integrationConfig.getUserId());
    }

    @Given("core deposit transaction with status {string}")
    public void changeDepositTransactionStatus(String statusStr) {
        var futureStatus = CoreTransactionStatus.findByName(statusStr);
        coreDB.updateTransactionStatus(futureStatus.getId(), DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId(), Configuration.integrationConfig.getUserId());
    }
}