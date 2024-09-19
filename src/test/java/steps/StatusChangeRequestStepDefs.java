package steps;

import configuration.Configuration;
import ge.singular.payment.api.rest.integration.StatusChangeRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.asserts.SoftAssert;

public class StatusChangeRequestStepDefs extends BaseSteps {
    public static StatusChangeRequest request;
    public static StatusChangeRequest.RequestBody requestBody;

    static {
        request = new StatusChangeRequest(Configuration.integrationConfig.getHost());
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("status change request body")
    public void getRequestBody() {
        requestBody = StatusChangeRequest.RequestBody.builder()
                .persistenceTransactionId(WithdrawRequestStepDefs.request.getResponseBody().getData().getTransactionId())
                .providerId(Configuration.serviceConfig.getProviderId())
                .coreTransactionId(CasinoCoreTransactionLookupStepDefs.fetchUsertransactionResponseItem.getTransactions().get(0).getID()).build();
    }

    @When("send status change request")
    public void sendRequest() {
        request.request(requestBody).deserialize();
    }

    @Then("status change response statusCode={int}, code={int}, message={string}")
    public void checkResponse(int statusCode, int code, String message) {
        SoftAssert softAssert = new SoftAssert();
        softAssert.assertEquals(request.getResponse().getStatusCode(), statusCode, "Incorrect status code!");
        softAssert.assertEquals((int) request.getResponseBody().getCode(), code, "Incorrect code");
        softAssert.assertEquals(request.getResponseBody().getMessage(), message, "Incorrect message!");
        softAssert.assertAll();
    }
}
