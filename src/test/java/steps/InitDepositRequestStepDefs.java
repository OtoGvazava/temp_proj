package steps;

import configuration.Configuration;
import ge.singular.payment.api.rest.integration.InitDepositRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.asserts.SoftAssert;

public class InitDepositRequestStepDefs extends BaseSteps {
    public static InitDepositRequest request;
    public static InitDepositRequest.RequestBody requestBody;

    static {
        request = new InitDepositRequest(Configuration.integrationConfig.getHost());
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("init deposit request body")
    public void setRequestBody() {
        requestBody = InitDepositRequest.RequestBody.builder()
                .userId(Configuration.integrationConfig.getUserId())
                .serviceId(Configuration.integrationConfig.getServiceId())
                // You need to add some other params here
                .build();

        throw new RuntimeException("You should add additional params above and remove this code line!");
    }

    @Given("init deposit request body action missing")
    public void setRequestBodyActionMissing() {
        requestBody = InitDepositRequest.RequestBody.builder()
                .userId(Configuration.integrationConfig.getUserId())
                .serviceId(Configuration.integrationConfig.getServiceId())
                // You need to add some other params here
                .build();

        throw new RuntimeException("You should add additional params above and remove this code line!");
    }

    @Given("init deposit request body service_id missing")
    public void setRequestBodyServiceIdMissing() {
        requestBody = InitDepositRequest.RequestBody.builder()
                .userId(Configuration.integrationConfig.getUserId())
                .serviceId(Configuration.integrationConfig.getServiceId())
                // You need to add some other params here
                .build();

        throw new RuntimeException("You should add additional params above and remove this code line!");
    }

    @When("send init deposit request")
    public void sendRequest() {
        request.request(Configuration.commonConfig.getProxyClientIp(), Configuration.commonConfig.getProxyAuthSecret(), requestBody).deserialize();
    }

    @When("send init deposit request hash is missing")
    public void sendRequestHashMissing() {
        request.requestWithoutHash(requestBody, Configuration.commonConfig.getProxyClientIp()).deserialize();
    }

    @When("send init deposit request hash is incorrect")
    public void sendRequestHashIncorrect() {
        request.request(requestBody,"test", Configuration.commonConfig.getProxyClientIp()).deserialize();
    }

    @Then("init deposit response statusCode={int}, code={int}, message={string}")
    public void checkResponse(int statusCode, int code, String message) {
        SoftAssert softAssert = new SoftAssert();
        softAssert.assertEquals(request.getResponse().getStatusCode(), statusCode, "Incorrect status code!");
        softAssert.assertEquals((int) request.getResponseBody().getCode(), code, "Incorrect code");
        softAssert.assertEquals(request.getResponseBody().getMessage(), message, "Incorrect message!");
        softAssert.assertAll();
    }
}
