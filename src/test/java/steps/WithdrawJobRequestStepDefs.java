package steps;

import configuration.Configuration;
import integration.job.WithdrawJobRequest;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.asserts.SoftAssert;

public class WithdrawJobRequestStepDefs extends BaseStepDefs {
    public static WithdrawJobRequest request;

    @Override
    public void reset() {
        request = null;
    }

    static {
        request = new WithdrawJobRequest(Configuration.INTEGRATION_HOST);
    }

    @When("send withdraw job request")
    public void sendRequest() {
        request.request(ConsulStepDefs.consulProperties.getJob().getSecret(),
                1000, -1000).deserialize();
    }

    @Then("withdraw job response statusCode={int}, code={int}, message={string}")
    public void checkResponse(int statusCode, int code, String message) {
        SoftAssert softAssert = new SoftAssert();
        softAssert.assertEquals(request.getResponse().getStatusCode(), statusCode, "Incorrect status code!");
        softAssert.assertEquals((int) request.getResponseBody().getCode(), code, "Incorrect code");
        softAssert.assertEquals(request.getResponseBody().getMessage(), message, "Incorrect message!");
        softAssert.assertAll();
    }
}
