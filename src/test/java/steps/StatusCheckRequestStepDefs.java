package steps;


import configuration.Configuration;
import ge.singular.payment.api.rest.integration.StatusCheckRequest;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.asserts.SoftAssert;

public class StatusCheckRequestStepDefs extends BaseSteps {
    public static StatusCheckRequest request;

    static {
        request = new StatusCheckRequest(Configuration.integrationConfig.getHost());
    }

    @Override
    public void reset() {
    }

    @When("send status check request")
    public void sendRequest() {
        request.request(DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId())
                .deserialize();
    }

    @Then("status check response statusCode={int}, code={int}, message={string}")
    public void checkResponse(int statusCode, int code, String message) {
        SoftAssert softAssert = new SoftAssert();
        softAssert.assertEquals(request.getResponse().getStatusCode(), statusCode, "Incorrect status code!");
        softAssert.assertEquals((int) request.getResponseBody().getCode(), code, "Incorrect code");
        softAssert.assertEquals(request.getResponseBody().getMessage(), message, "Incorrect message!");
        softAssert.assertAll();
    }

    @Then("check status check response data")
    public void checkData() {
        SoftAssert softAssert = new SoftAssert();
        softAssert.assertEquals(request.getResponseBody().getData().getTransactionId(),
                DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId(),
                "Incorrect transaction ID!");
        softAssert.assertEquals(request.getResponseBody().getData().getTransactionType(), "ProviderToCore",
                "Transaction type is incorrect!");
        softAssert.assertEquals(request.getResponseBody().getData().getFee(),
                DepositRequestStepDefs.requestBody.getFee(), "Incorrect fee!");
        softAssert.assertEquals(request.getResponseBody().getData().getAmount(),
                DepositRequestStepDefs.requestBody.getAmount(), "Incorrect amount!");
        softAssert.assertEquals(request.getResponseBody().getData().getProviderTransactionId(), "115109892", "Incorrect provider transaction id!");
        softAssert.assertEquals((int) request.getResponseBody().getData().getProviderTransactionStatus(), 2, "Incorrect provider transaction status!");
        softAssert.assertAll();
    }
}
