package steps;

import configuration.Configuration;
import ge.singular.authproxy.api.AuthProxyWithdrawRequest;
import ge.singular.payment.api.rest.integration.WithdrawRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.Assert;

public class AuthProxyWithdrawStepDefs extends BaseStepDefs {
    public static AuthProxyWithdrawRequest request;
    public static WithdrawRequest.RequestBody requestBody;

    static {
        request = new AuthProxyWithdrawRequest(Configuration.commonConfig.getAuthProxyApi());
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("auth proxy withdraw request body")
    public void getRequestBody() {
        requestBody = WithdrawRequest.RequestBody.builder()
                .serviceName(Configuration.integrationConfig.getServiceName())
                .serviceId(AuthProxyInitWithdrawStepDefs.requestBody.getServiceId())
                // here
                .session(AuthProxyInitWithdrawStepDefs.request.getResponseBody().getRules().getSession()).build();

        throw new RuntimeException("You should add additional params above and remove this code line!");
    }

    @When("send auth proxy withdraw request")
    public void sendRequest() {
        request.request(requestBody, Configuration.commonConfig.getOriginReferrer(), Configuration.integrationConfig.getUserId(),
                CoreApiLoginStepDefs.coreApiWebsiteServiceRequest.getResponse().getHeaders().getValues("set-cookie").get(0))
                .deserialize();
    }

    @Then("check auth proxy withdraw response http status code equals to {int}")
    public void checkHttpStatusCode(int statusCode) {
        Assert.assertEquals(request.getResponse().getStatusCode(), statusCode,
                "Incorrect http status code!");
    }

    @Then("check auth proxy withdraw response code equals to {int}")
    public void checkStatusCode(int code) {
        Assert.assertEquals(request.getResponseBody().getCode(), code,
                "Incorrect code!");
    }

    @Then("check auth proxy withdraw response message equals to {string}")
    public void checkErrorCode(String message) {
        Assert.assertEquals(request.getResponseBody().getMessage(), message,
                "Incorrect message!");
    }
}