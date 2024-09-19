package steps;

import configuration.Configuration;
import ge.singular.coreapi.api.CoreApiWebsiteServiceRequest;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.Assert;

public class CoreApiLoginStepDefs extends BaseSteps {
    public static CoreApiWebsiteServiceRequest coreApiWebsiteServiceRequest;

    static {
        coreApiWebsiteServiceRequest = new CoreApiWebsiteServiceRequest(Configuration.commonConfig.getCoreIntegrationApi());
    }

    @Override
    public void reset() {
        coreApiWebsiteServiceRequest = null;
    }

    @When("send core api login request")
    public void sendLoginRequest() {
        coreApiWebsiteServiceRequest.request(Configuration.integrationConfig.getUserName(), Configuration.integrationConfig.getUserPassword(), 1,
                        "login", Configuration.commonConfig.getOriginReferrer())
                .deserialize();
    }

    @Then("check core api response http status code equals to {int}")
    public void checkHttpStatusCode(int statusCode) {
        Assert.assertEquals(coreApiWebsiteServiceRequest.getResponse().getStatusCode(), statusCode,
                "Incorrect http status code!");
    }

    @Then("check core api response StatusCode equals to {int}")
    public void checkStatusCode(int statusCode) {
        Assert.assertEquals(coreApiWebsiteServiceRequest.getResponseBody().getStatusCode(), statusCode,
                "Incorrect status code!");
    }

    @Then("check core api response ErrorCode equals to null")
    public void checkErrorCode() {
        Assert.assertNull(coreApiWebsiteServiceRequest.getResponseBody().getErrorCode(),
                "Incorrect error code!");
    }
}