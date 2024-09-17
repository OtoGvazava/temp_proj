package steps;

import configuration.Configuration;
import ge.singular.common.data.Currency;
import ge.singular.payment.api.rest.integration.payment.InitWithdrawRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.apache.commons.lang3.RandomStringUtils;
import org.testng.asserts.SoftAssert;

import java.util.List;

public class InitWithdrawRequestStepDefs extends BaseStepDefs {
    public static InitWithdrawRequest request;
    public static InitWithdrawRequest.RequestBody requestBody;

    static {
        request = new InitWithdrawRequest(Configuration.INTEGRATION_HOST);
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("init withdraw request body")
    public void setRequestBody() {
        requestBody = InitWithdrawRequest.RequestBody.builder()
                .userId(OtherStepDefs.userId)
                .amount(10)
                .currency(Currency.EUR.name())
                .fee(5)
                .serviceId(OtherStepDefs.serviceId)
                .actions(List.of(1))
                .account(RandomStringUtils.randomAlphabetic(10) + "@gmail.com")
                .channel(1)
                .build();
    }

    @Given("init withdraw request body action missing")
    public void setRequestBodyActionMissing() {
        requestBody = InitWithdrawRequest.RequestBody.builder()
                .userId(OtherStepDefs.userId)
                .amount(10)
                .currency(Currency.EUR.name())
                .fee(5)
                .serviceId(OtherStepDefs.serviceId)
                .account(RandomStringUtils.randomAlphabetic(10) + "@gmail.com")
                .channel(1)
                .build();
    }

    @Given("init withdraw request body service_id missing")
    public void setRequestBodyServiceIdMissing() {
        requestBody = InitWithdrawRequest.RequestBody.builder()
                .userId(OtherStepDefs.userId)
                .amount(10)
                .currency(Currency.EUR.name())
                .fee(5)
                .actions(List.of(1))
                .account(RandomStringUtils.randomAlphabetic(10) + "@gmail.com")
                .channel(1)
                .build();
    }

    @When("send init withdraw request hash is missing")
    public void sendRequestHashMissing() {
        request.requestWithoutHash(requestBody, Configuration.PROXY_CLIENT_IP).deserialize();
    }

    @When("send init withdraw request hash is incorrect")
    public void sendRequestHashIncorrect() {
        request.request(requestBody,"test", Configuration.PROXY_CLIENT_IP).deserialize();
    }

    @When("send init withdraw request")
    public void sendRequest() {
        request.request(Configuration.PROXY_CLIENT_IP, Configuration.PROXY_AUTH_SECRET, requestBody).deserialize();
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
