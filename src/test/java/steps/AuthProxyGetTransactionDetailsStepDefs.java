package steps;

import configuration.Configuration;
import ge.singular.authproxy.api.AuthProxyGetTransactionDetails;
import ge.singular.payment.api.rest.integration.GetTransactionDetailsRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.Assert;

public class AuthProxyGetTransactionDetailsStepDefs extends BaseStepDefs {
    public static AuthProxyGetTransactionDetails request;
    public static GetTransactionDetailsRequest.RequestBody requestBody;

    static {
        request = new AuthProxyGetTransactionDetails(Configuration.commonConfig.getAuthProxyApi());
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("auth proxy get transaction details request body")
    public void getRequestBody() {
        requestBody = GetTransactionDetailsRequest.RequestBody.builder()
                .serviceName(Configuration.integrationConfig.getServiceName())
                .transactionId(AuthProxyDepositStepDefs.request.getResponseBody().getData().getTransactionId().toString())
                .userId(Configuration.integrationConfig.getUserId()).build();
    }

    @When("send auth proxy get transaction details request")
    public void sendRequest() {
        request.request(requestBody, Configuration.commonConfig.getOriginReferrer(), Configuration.integrationConfig.getUserId(),
                CoreApiLoginStepDefs.coreApiWebsiteServiceRequest.getResponse().getHeaders().getValues("set-cookie").get(0))
                .deserialize();
    }

    @Then("check auth proxy get transaction details response http status code equals to {int}")
    public void checkHttpStatusCode(int statusCode) {
        Assert.assertEquals(request.getResponse().getStatusCode(), statusCode,
                "Incorrect http status code!");
    }

    @Then("check auth proxy get transaction details response code equals to {int}")
    public void checkStatusCode(int code) {
        Assert.assertEquals(request.getResponseBody().getCode(), code,
                "Incorrect code!");
    }

    @Then("check auth proxy get transaction details response message equals to {string}")
    public void checkErrorCode(String message) {
        Assert.assertEquals(request.getResponseBody().getMessage(), message,
                "Incorrect message!");
    }

    @Then("check auth proxy get transaction details response data")
    public void checkAccountsThanZero() {
        Assert.assertEquals(request.getResponseBody().getData().getUserId(), Configuration.integrationConfig.getUserId(),
                "Incorrect user id!");
    }
}
