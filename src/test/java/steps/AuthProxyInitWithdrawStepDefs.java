package steps;

import configuration.Configuration;
import ge.singular.authproxy.api.AuthProxyInitWithdrawRequest;
import ge.singular.payment.api.rest.integration.InitWithdrawRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.Assert;

public class AuthProxyInitWithdrawStepDefs extends BaseSteps {
    public static AuthProxyInitWithdrawRequest request;
    public static AuthProxyInitWithdrawRequest.RequestBody requestBody;

    static {
        request = new AuthProxyInitWithdrawRequest(Configuration.commonConfig.getAuthProxyApi());
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("auth proxy init withdraw request body")
    public void getRequestBody() {
        requestBody = AuthProxyInitWithdrawRequest.RequestBody.builder()
                .serviceName(Configuration.integrationConfig.getServiceName())
                .serviceId(Configuration.integrationConfig.getServiceId())
                // here
                .build();

        throw new RuntimeException("You should add additional params above and remove this code line!");
    }

    @When("send auth proxy init withdraw request")
    public void sendRequest() {
        request.request(requestBody, Configuration.commonConfig.getOriginReferrer(), Configuration.integrationConfig.getUserId(),
                CoreApiLoginStepDefs.coreApiWebsiteServiceRequest.getResponse().getHeaders().getValues("set-cookie").get(0))
                .deserialize();
    }

    @Then("check auth proxy init withdraw response http status code equals to {int}")
    public void checkHttpStatusCode(int statusCode) {
        Assert.assertEquals(request.getResponse().getStatusCode(), statusCode,
                "Incorrect http status code!");
    }

    @Then("check auth proxy init withdraw response code equals to {int}")
    public void checkStatusCode(int code) {
        Assert.assertEquals(request.getResponseBody().getCode(), code,
                "Incorrect code!");
    }

    @Then("check auth proxy init withdraw response message equals to {string}")
    public void checkErrorCode(String message) {
        Assert.assertEquals(request.getResponseBody().getMessage(), message,
                "Incorrect message!");
    }
}
