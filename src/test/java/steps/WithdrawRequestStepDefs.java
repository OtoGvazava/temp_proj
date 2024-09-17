package steps;

import configuration.Configuration;
import ge.singular.payment.api.rest.integration.WithdrawRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.asserts.SoftAssert;

import java.util.Arrays;

public class WithdrawRequestStepDefs extends BaseStepDefs {
    public static WithdrawRequest request;
    public static WithdrawRequest.RequestBody requestBody;

    static  {
        request = new WithdrawRequest(Configuration.integrationConfig.getHost());
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("withdraw request body")
    public void requestBody() {
        requestBody = WithdrawRequest.RequestBody.builder()
                .userId(Configuration.integrationConfig.getUserId())
                .serviceId(Configuration.integrationConfig.getServiceId())
                .fee(100)
                .amount(1000)
                .actions(Arrays.asList(1, 4))
                .channel(1).build();
    }



    @When("send withdraw request")
    public void sendWithdrawRequest() {
        request.request(Configuration.commonConfig.getProxyClientIp(), Configuration.commonConfig.getProxyAuthSecret(), requestBody).deserialize();
    }

    @Then("withdraw response statusCode={int}, code={int}, message={string}")
    public void checkResponse(int statusCode, int code, String message) {
        SoftAssert softAssert = new SoftAssert();
        softAssert.assertEquals(request.getResponse().getStatusCode(), statusCode, "Incorrect status code!");
        softAssert.assertEquals((int) request.getResponseBody().getCode(), code, "Incorrect code");
        softAssert.assertEquals(request.getResponseBody().getMessage(), message, "Incorrect message!");
        softAssert.assertAll();
    }
}