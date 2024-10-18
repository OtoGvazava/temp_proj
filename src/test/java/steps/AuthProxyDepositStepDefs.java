package steps;

import configuration.Configuration;
import ge.singular.authproxy.api.AuthProxyDepositRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.Assert;

public class AuthProxyDepositStepDefs extends BaseSteps {
    public static AuthProxyDepositRequest request;
    public static AuthProxyDepositRequest.RequestBody requestBody;

    static {
        request = new AuthProxyDepositRequest(Configuration.commonConfig.getAuthProxyApi());
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("auth proxy deposit request body")
    public void getRequestBody() {
        requestBody = AuthProxyDepositRequest.RequestBody.builder()
                .serviceName(Configuration.integrationConfig.getServiceName())
                .serviceId(AuthProxyInitDepositStepDefs.requestBody.getServiceId())
                // You need to add some other params here
                .session(AuthProxyInitDepositStepDefs.request.getResponseBody().getRules().getSession()).build();

        throw new RuntimeException("You should add additional params above and remove this code line!");
    }

    @When("send auth proxy deposit request")
    public void sendRequest() {
        request.request(requestBody, Configuration.commonConfig.getOriginReferrer(), Configuration.integrationConfig.getUserId(),
                CoreApiLoginStepDefs.coreApiWebsiteServiceRequest.getResponse().getHeaders().getValues("set-cookie").get(0))
                .deserialize();
    }

    @Then("check auth proxy deposit response http status code equals to {int}")
    public void checkHttpStatusCode(int statusCode) {
        Assert.assertEquals(request.getResponse().getStatusCode(), statusCode,
                "Incorrect http status code!");
    }

    @Then("check auth proxy deposit response code equals to {int}")
    public void checkStatusCode(int code) {
        Assert.assertEquals(request.getResponseBody().getCode(), code,
                "Incorrect code!");
    }

    @Then("check auth proxy deposit response message equals to {string}")
    public void checkErrorCode(String message) {
        Assert.assertEquals(request.getResponseBody().getMessage(), message,
                "Incorrect message!");
    }
}