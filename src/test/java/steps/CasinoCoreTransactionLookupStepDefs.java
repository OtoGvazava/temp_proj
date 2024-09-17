package steps;

import configuration.Configuration;
import ge.singular.casinocore.integration.FetchUsertransactionResponseItem;
import ge.singular.casinocore.transactionlookup.CasinoCoreTransactionLookup;
import ge.singular.casinocore.transactionlookup.CasinoCoreTransactionLookup_Service;
import ge.singular.common.utils.HashGenerator;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.Assert;

public class CasinoCoreTransactionLookupStepDefs extends BaseStepDefs {
    private final CasinoCoreTransactionLookup casinoCoreTransactionLookup;

    public CasinoCoreTransactionLookupStepDefs() {
        var service = new CasinoCoreTransactionLookup_Service();
        casinoCoreTransactionLookup = service.getCasinoCoreTransactionLookupPort();
    }

    public static FetchUsertransactionResponseItem fetchUsertransactionResponseItem;

    @Override
    public void reset() {
        fetchUsertransactionResponseItem = null;
    }

    @When("send get core user transactions request for withdraw")
    public void sendGetCoreUserTransactions() {
        String hash = HashGenerator.generateHash(Configuration.SIS_PROVIDER_ID.toString() +
                OtherStepDefs.userId +
                ConsulStepDefs.consulProperties.getProviderId() +
                OtherStepDefs.serviceId +
                WithdrawRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString() +
                false +
                0 +
                1 +
                Configuration.SIS_PROVIDER_SECRET);
        fetchUsertransactionResponseItem = casinoCoreTransactionLookup.getUsersTransactions(
                Configuration.SIS_PROVIDER_ID.toString(),
                null,
                (long) OtherStepDefs.userId,
                null,
                null,
                ConsulStepDefs.consulProperties.getProviderId(),
                OtherStepDefs.serviceId,
                WithdrawRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString(),
                null,
                null,
                null,
                false,
                null,
                null,
                0,
                1,
                hash
        );
    }

    @Then("core user transaction response status code equals {int}")
    public void checkCoreUserTransactionHttpStatusCode(int statusCode) {
        Assert.assertEquals(fetchUsertransactionResponseItem.getStatusCode(), statusCode,
                "Incorrect http status code!");
    }

//    @Then("check core user transaction details with fee, status equals to {string}")
//    public void checkCoreUserTransactionDetailsWithFee(String statusStr) {
//        CoreTransactionStatus status = CoreTransactionStatus.findByName(statusStr);
//        SoftAssert softAssert = new SoftAssert();
//        UsertransactionItem usertransactionItem = fetchUsertransactionResponseItem.getTransactions().get(0);
//        softAssert.assertEquals(usertransactionItem.getUserID(), (long) OtherStepDefs.userId, "Incorrect user id");
//        softAssert.assertEquals(usertransactionItem.getTransactionStatus(), status.getId(),
//                "Incorrect transaction status!");
//        softAssert.assertEquals(usertransactionItem.getTxFeeAmount().doubleValue(), (double)DepositStepDefs.requestBody.getFee(),
//                "Incorrect fee amount!");
//        softAssert.assertEquals(usertransactionItem.getProviderServiceID(), OtherStepDefs.serviceId,
//                "Incorrect service id!");
//        softAssert.assertAll();
//    }

//    @Then("check core user transaction details, status equals to {string}")
//    public void checkCoreUserTransactionDetails(String statusStr) {
//        CoreTransactionStatus status = CoreTransactionStatus.findByName(statusStr);
//        SoftAssert softAssert = new SoftAssert();
//        UsertransactionItem usertransactionItem = fetchUsertransactionResponseItem.getTransactions().get(0);
//        softAssert.assertEquals(usertransactionItem.getUserID(), (long) OtherStepDefs.userId, "Incorrect user id");
//        softAssert.assertEquals(usertransactionItem.getTransactionStatus(), status.getId(),
//                "Incorrect transaction status!");
//        softAssert.assertEquals(usertransactionItem.getProviderServiceID(), OtherStepDefs.serviceId,
//                "Incorrect service id!");
//        softAssert.assertAll();
//    }
}