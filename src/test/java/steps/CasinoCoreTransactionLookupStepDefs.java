package steps;

import configuration.Configuration;
import ge.singular.casinocore.integration.FetchUsertransactionResponseItem;
import ge.singular.casinocore.transactionlookup.CasinoCoreTransactionLookup;
import ge.singular.casinocore.transactionlookup.CasinoCoreTransactionLookup_Service;
import ge.singular.common.utils.HashGenerator;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.Assert;

public class CasinoCoreTransactionLookupStepDefs extends BaseSteps {
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
    public void sendGetCoreUserTransactionsWithdraw() {
        String hash = HashGenerator.generateHash(Configuration.integrationConfig.getSisProviderId() +
                Configuration.integrationConfig.getUserId() +
                Configuration.serviceConfig.getProviderId() +
                Configuration.integrationConfig.getServiceId() +
                WithdrawRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString() +
                false +
                0 +
                1 +
                Configuration.integrationConfig.getSisProviderSecret());
        fetchUsertransactionResponseItem = casinoCoreTransactionLookup.getUsersTransactions(
                Configuration.integrationConfig.getSisProviderId(),
                null,
                (long) Configuration.integrationConfig.getUserId(),
                null,
                null,
                Configuration.serviceConfig.getProviderId(),
                Configuration.integrationConfig.getServiceId(),
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

    @When("send get core user transactions request for deposit")
    public void sendGetCoreUserTransactionsDeposit() {
        String hash = HashGenerator.generateHash(Configuration.integrationConfig.getSisProviderId() +
                Configuration.integrationConfig.getUserId() +
                Configuration.serviceConfig.getProviderId() +
                Configuration.integrationConfig.getServiceId() +
                WithdrawRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString() +
                false +
                0 +
                1 +
                Configuration.integrationConfig.getSisProviderSecret());
        fetchUsertransactionResponseItem = casinoCoreTransactionLookup.getUsersTransactions(
                Configuration.integrationConfig.getSisProviderId(),
                null,
                (long) Configuration.integrationConfig.getUserId(),
                null,
                null,
                Configuration.serviceConfig.getProviderId(),
                Configuration.integrationConfig.getServiceId(),
                DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString(),
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
}