package steps;

import configuration.Configuration;
import ge.singular.authproxy.api.AuthProxyGetPaymentAccountsRequest;
import ge.singular.payment.api.rest.integration.GetAccountsRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.Assert;

public class AuthProxyGetPaymentAccountsStepDefs extends BaseStepDefs {
    public static AuthProxyGetPaymentAccountsRequest request;
    public static GetAccountsRequest.RequestBody requestBody;

    static {
        request = new AuthProxyGetPaymentAccountsRequest(Configuration.commonConfig.getAuthProxyApi());
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("auth proxy get payment accounts request body")
    public void getRequestBody() {
        requestBody = GetAccountsRequest.RequestBody.builder()
                .serviceName(Configuration.integrationConfig.getServiceName())
                .serviceId(Configuration.integrationConfig.getServiceId())
                .isRecurring(false).build();
    }

    @When("send auth proxy get payment accounts request")
    public void sendRequest() {
        request.request(requestBody, Configuration.commonConfig.getOriginReferrer(), Configuration.integrationConfig.getUserId(),
                CoreApiLoginStepDefs.coreApiWebsiteServiceRequest.getResponse().getHeaders().getValues("set-cookie").get(0))
                .deserialize();
    }

    @Then("check auth proxy get payment accounts response http status code equals to {int}")
    public void checkHttpStatusCode(int statusCode) {
        Assert.assertEquals(request.getResponse().getStatusCode(), statusCode,
                "Incorrect http status code!");
    }

    @Then("check auth proxy get payment accounts response code equals to {int}")
    public void checkStatusCode(int code) {
        Assert.assertEquals(request.getResponseBody().getCode(), code,
                "Incorrect code!");
    }

    @Then("check auth proxy get payment accounts response message equals to {string}")
    public void checkErrorCode(String message) {
        Assert.assertEquals(request.getResponseBody().getMessage(), message,
                "Incorrect message!");
    }

    @Then("check auth proxy get payment accounts response items size is more than zero")
    public void checkAccountsThanZero() {
        Assert.assertFalse(request.getResponseBody().getData().isEmpty(), "List size should be more than zero");
    }
}
