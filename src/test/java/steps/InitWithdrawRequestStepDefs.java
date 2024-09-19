package steps;

import configuration.Configuration;
import ge.singular.common.data.Currency;
import ge.singular.payment.api.rest.integration.InitWithdrawRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.apache.commons.lang3.RandomStringUtils;
import org.testng.asserts.SoftAssert;

import java.util.List;

public class InitWithdrawRequestStepDefs extends BaseSteps {
    public static InitWithdrawRequest request;
    public static InitWithdrawRequest.RequestBody requestBody;

    static {
        request = new InitWithdrawRequest(Configuration.integrationConfig.getHost());
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("init withdraw request body")
    public void setRequestBody() {
        requestBody = InitWithdrawRequest.RequestBody.builder()
                .userId(Configuration.integrationConfig.getUserId())
                .serviceId(Configuration.integrationConfig.getServiceId())
                // You need to add some other params here
                .build();

        throw new RuntimeException("You should add additional params above and remove this code line!");
    }

    @Given("init withdraw request body action missing")
    public void setRequestBodyActionMissing() {
        requestBody = InitWithdrawRequest.RequestBody.builder()
                .userId(Configuration.integrationConfig.getUserId())
                .serviceId(Configuration.integrationConfig.getServiceId())
                // You need to add some other params here
                .build();

        throw new RuntimeException("You should add additional params above and remove this code line!");
    }

    @Given("init withdraw request body service_id missing")
    public void setRequestBodyServiceIdMissing() {
        requestBody = InitWithdrawRequest.RequestBody.builder()
                .userId(Configuration.integrationConfig.getUserId())
                // You need to add some other params here
                .build();

        throw new RuntimeException("You should add additional params above and remove this code line!");
    }

    @When("send init withdraw request hash is missing")
    public void sendRequestHashMissing() {
        request.requestWithoutHash(requestBody, Configuration.commonConfig.getProxyClientIp()).deserialize();
    }

    @When("send init withdraw request hash is incorrect")
    public void sendRequestHashIncorrect() {
        request.request(requestBody,"test", Configuration.commonConfig.getProxyClientIp()).deserialize();
    }

    @When("send init withdraw request")
    public void sendRequest() {
        request.request(Configuration.commonConfig.getProxyClientIp(), Configuration.commonConfig.getProxyAuthSecret(), requestBody).deserialize();
    }

    @Then("init withdraw response statusCode={int}, code={int}, message={string}")
    public void checkResponse(int statusCode, int code, String message) {
        SoftAssert softAssert = new SoftAssert();
        softAssert.assertEquals(request.getResponse().getStatusCode(), statusCode, "Incorrect status code!");
        softAssert.assertEquals((int) request.getResponseBody().getCode(), code, "Incorrect code");
        softAssert.assertEquals(request.getResponseBody().getMessage(), message, "Incorrect message!");
        softAssert.assertAll();
    }
}
