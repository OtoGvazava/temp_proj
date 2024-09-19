package steps;

import configuration.Configuration;
import ge.singular.payment.api.rest.integration.GetAccountsRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.Assert;
import org.testng.asserts.SoftAssert;

public class GetAccountsStepDefs extends BaseSteps {
    public static GetAccountsRequest request;
    public static GetAccountsRequest.RequestBody requestBody;

    static {
        request = new GetAccountsRequest(Configuration.integrationConfig.getHost());
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("get accounts request body with incorrect user id")
    public void requestBodyIncorrectUserId() {
        requestBody = GetAccountsRequest.RequestBody.builder()
                .userId(999999999)
                .serviceId(Configuration.integrationConfig.getServiceId())
                .isRecurring(false).build();
    }

    @Given("get accounts request body with incorrect service id")
    public void requestBodyIncorrectServiceId() {
        requestBody = GetAccountsRequest.RequestBody.builder()
                .userId(Configuration.integrationConfig.getUserId())
                .serviceId(999999999)
                .isRecurring(false).build();
    }

    @Given("get accounts request body with is_recurring={string}")
    public void requestBodyIncorrectServiceId(String isRecurringStr) {
        var isRecurring = Boolean.parseBoolean(isRecurringStr);
        requestBody = GetAccountsRequest.RequestBody.builder()
                .userId(Configuration.integrationConfig.getUserId())
                .serviceId(Configuration.integrationConfig.getServiceId())
                .isRecurring(isRecurring).build();
    }

    @When("send get accounts request")
    public void sendRequest() {
        request.request(Configuration.commonConfig.getProxyClientIp(), Configuration.commonConfig.getProxyAuthSecret(), requestBody)
                .deserialize();
    }

    @Then("get accounts response statusCode={int}, code={int}, message={string}")
    public void checkResponse(int statusCode, int code, String message) {
        SoftAssert softAssert = new SoftAssert();
        softAssert.assertEquals(request.getResponse().getStatusCode(), statusCode, "Incorrect status code!");
        softAssert.assertEquals((int) request.getResponseBody().getCode(), code, "Incorrect code");
        softAssert.assertEquals(request.getResponseBody().getMessage(), message, "Incorrect message!");
        softAssert.assertAll();
    }

    @Then("get accounts data object is empty")
    public void checkDataIsEmpty() {
        Assert.assertTrue(request.getResponseBody().getData().isEmpty(), "Data object should be empty!");
    }

    @Then("get accounts data object is not empty")
    public void checkDataIsNotEmpty() {
        Assert.assertFalse(request.getResponseBody().getData().isEmpty(), "Data object should not be empty!");
    }
}