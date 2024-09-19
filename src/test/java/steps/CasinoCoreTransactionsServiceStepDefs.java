package steps;

import configuration.Configuration;
import ge.singular.casinocore.data.CoreTransactionStatus;
import ge.singular.casinocore.transactions.CasinoCoreTransactions;
import ge.singular.casinocore.transactions.CasinoCoreTransactions_Service;
import ge.singular.common.utils.HashGenerator;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.Assert;

public class CasinoCoreTransactionsServiceStepDefs extends BaseSteps {
    private final CasinoCoreTransactions casinoCoreTransactions;

    public CasinoCoreTransactionsServiceStepDefs() {
        var service = new CasinoCoreTransactions_Service();
        casinoCoreTransactions = service.getCasinoCoreTransactionsPort();
    }

    public static int resultCode;

    @Override
    public void reset() {

    }

    @When("send core transaction status change request as approved")
    public void sendChangeTransactionStatusRequestApproved() {
        var hash = HashGenerator.generateHash(Configuration.integrationConfig.getSisProviderId() +
                        CasinoCoreTransactionLookupStepDefs.fetchUsertransactionResponseItem.getTransactions().get(0).getID() +
                        (short) CoreTransactionStatus.Approved.getId() +
                        "test" +
                        "test" +
                Configuration.integrationConfig.getSisProviderSecret());

        resultCode = casinoCoreTransactions.changeTransactionStatus(Configuration.integrationConfig.getSisProviderId(),
                CasinoCoreTransactionLookupStepDefs.fetchUsertransactionResponseItem.getTransactions().get(0).getID(),
                (short) CoreTransactionStatus.Approved.getId(),
                "test",
                "test",
                hash);
    }

    @When("send core transaction status change request as rejected")
    public void sendChangeTransactionStatusRequestRejected() {
        var hash = HashGenerator.generateHash(Configuration.integrationConfig.getSisProviderId() +
                CasinoCoreTransactionLookupStepDefs.fetchUsertransactionResponseItem.getTransactions().get(0).getID() +
                (short) CoreTransactionStatus.Rejected.getId() +
                "test" +
                "test" +
                Configuration.integrationConfig.getSisProviderSecret());

        resultCode = casinoCoreTransactions.changeTransactionStatus(Configuration.integrationConfig.getSisProviderId(),
                CasinoCoreTransactionLookupStepDefs.fetchUsertransactionResponseItem.getTransactions().get(0).getID(),
                (short) CoreTransactionStatus.Rejected.getId(),
                "test",
                "test",
                hash);
    }

    @Then("result code of core transaction status change request equals {int}")
    public void checkHttpStatusCodeAndResultCode(int code) {
        Assert.assertEquals(code, resultCode, "Incorrect result code!");
    }
}
