package steps;

import configuration.Configuration;
import ge.singular.payment.api.rest.integration.DepositRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.asserts.SoftAssert;

import java.util.Arrays;

public class DepositRequestStepDefs extends BaseStepDefs {
    public static DepositRequest request;
    public static DepositRequest.RequestBody requestBody;

    static {
        request = new DepositRequest(Configuration.integrationConfig.getHost());
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("deposit request body")
    public void requestBody() {
        requestBody = DepositRequest.RequestBody.builder()
                // here
                .actions(Arrays.asList(1, 4))
                .amount(1000)
                .fee(100)
                .userId(Configuration.integrationConfig.getUserId())
                .serviceId(Configuration.integrationConfig.getServiceId()).build();

        throw new RuntimeException("You should add additional params above and remove this code line!");
    }

    @When("send deposit request")
    public void sendRequest() {
        request.request(Configuration.commonConfig.getProxyClientIp(), Configuration.commonConfig.getProxyAuthSecret(), requestBody)
                .deserialize();
    }

    @Then("deposit response statusCode={int}, code={int}, message={string}")
    public void checkResponse(int statusCode, int code, String message) {
        SoftAssert softAssert = new SoftAssert();
        softAssert.assertEquals(request.getResponse().getStatusCode(), statusCode, "Incorrect status code!");
        softAssert.assertEquals((int) request.getResponseBody().getCode(), code, "Incorrect code");
        softAssert.assertEquals(request.getResponseBody().getMessage(), message, "Incorrect message!");
        softAssert.assertAll();
    }

    @Then("check deposit response data parameters")
    public void checkResponseData() {
        var data = request.getResponseBody().getData();
        var softAssert = new SoftAssert();
        // here
        softAssert.assertAll();

        throw new RuntimeException("You should add additional asserts above and remove this code line!");
    }
}