package steps;

import configuration.Configuration;
import ge.singular.payment.api.rest.integration.DepositJobRequest;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.asserts.SoftAssert;

public class DepositJobRequestStepDefs extends BaseSteps {
    public static DepositJobRequest request;

    @Override
    public void reset() {
        request = null;
    }

    static {
        request = new DepositJobRequest(Configuration.integrationConfig.getHost());
    }

    @When("send deposit job request")
    public void sendRequest() {
        request.request(Configuration.serviceConfig.getJob().getSecret(),
                1000, -1000).deserialize();
    }

    @Then("deposit job response statusCode={int}, code={int}, message={string}")
    public void checkResponse(int statusCode, int code, String message) {
        SoftAssert softAssert = new SoftAssert();
        softAssert.assertEquals(request.getResponse().getStatusCode(), statusCode, "Incorrect status code!");
        softAssert.assertEquals((int) request.getResponseBody().getCode(), code, "Incorrect code");
        softAssert.assertEquals(request.getResponseBody().getMessage(), message, "Incorrect message!");
        softAssert.assertAll();
    }
}