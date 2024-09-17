package steps;

import ge.singular.common.data.Currency;
import integration.callback.DepositCallbackRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.testng.asserts.SoftAssert;

import static configuration.Configuration.INTEGRATION_HOST;

public class DepositCallbackStepDefs extends BaseStepDefs {
    public static DepositCallbackRequest request;
    public static DepositCallbackRequest.RequestParams requestParams;

    static {
        request = new DepositCallbackRequest(INTEGRATION_HOST);
    }

    @Override
    public void reset() {
        request = null;
        requestParams = null;
    }

    @Given("deposit callback request params with status Success")
    public void requestParams() {
        requestParams = DepositCallbackRequest.RequestParams.builder()
                .payToEmail(ConsulStepDefs.consulProperties.extended.api.eur.username)
                .payFromEmail(DepositRequestStepDefs.request.getResponseBody().getData().getUrlParameters().getParameters().getPayFromEmail())
                .merchantId("213213")
                .customerId("2123")
                .transactionId(DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString())
                .mbAmount((double) DepositRequestStepDefs.requestBody.getAmount() / 100)
                .mbCurrency(Currency.EUR.name())
                .status(ConsulStepDefs.consulProperties.extended.statusCodes.success)
                .amount((double) DepositRequestStepDefs.requestBody.getAmount() / 100)
                .currency(Currency.EUR.name()).build();
    }

    @Given("deposit callback request params with different amount in deposit")
    public void requestParamsWithDifferentAmountInDeposit() {
        requestParams = DepositCallbackRequest.RequestParams.builder()
                .payToEmail(ConsulStepDefs.consulProperties.extended.api.eur.username)
                .payFromEmail(DepositRequestStepDefs.request.getResponseBody().getData().getUrlParameters().getParameters().getPayFromEmail())
                .merchantId("213213")
                .customerId("2123")
                .transactionId(DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString())
                .mbAmount(123.0)
                .mbCurrency(Currency.EUR.name())
                .status(ConsulStepDefs.consulProperties.extended.statusCodes.success)
                .amount(123.0)
                .currency(Currency.EUR.name()).build();
    }

    @Given("deposit callback request params with different currency in deposit")
    public void requestParamsWithDifferentCurrencyInDeposit() {
        requestParams = DepositCallbackRequest.RequestParams.builder()
                .payToEmail(ConsulStepDefs.consulProperties.extended.api.eur.username)
                .payFromEmail(DepositRequestStepDefs.request.getResponseBody().getData().getUrlParameters().getParameters().getPayFromEmail())
                .merchantId("213213")
                .customerId("2123")
                .transactionId(DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString())
                .mbAmount((double) DepositRequestStepDefs.requestBody.getAmount() / 100)
                .mbCurrency(Currency.USD.name())
                .status(ConsulStepDefs.consulProperties.extended.statusCodes.success)
                .amount((double) DepositRequestStepDefs.requestBody.getAmount() / 100)
                .currency(Currency.USD.name()).build();
    }

    @Given("deposit callback request params with status Pending")
    public void requestParamsStatusPending() {
        requestParams = DepositCallbackRequest.RequestParams.builder()
                .payToEmail(ConsulStepDefs.consulProperties.extended.api.eur.username)
                .payFromEmail(DepositRequestStepDefs.request.getResponseBody().getData().getUrlParameters().getParameters().getPayFromEmail())
                .merchantId("213213")
                .customerId("2123")
                .transactionId(DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString())
                .mbAmount((double) DepositRequestStepDefs.requestBody.getAmount() / 100)
                .mbCurrency(Currency.EUR.name())
                .status(ConsulStepDefs.consulProperties.extended.statusCodes.pending)
                .amount((double) DepositRequestStepDefs.requestBody.getAmount() / 100)
                .currency(Currency.EUR.name()).build();
    }

    @Given("deposit callback request params with status Scheduled")
    public void requestParamsStatusScheduled() {
        requestParams = DepositCallbackRequest.RequestParams.builder()
                .payToEmail(ConsulStepDefs.consulProperties.extended.api.eur.username)
                .payFromEmail(DepositRequestStepDefs.request.getResponseBody().getData().getUrlParameters().getParameters().getPayFromEmail())
                .merchantId("213213")
                .customerId("2123")
                .transactionId(DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString())
                .mbAmount((double) DepositRequestStepDefs.requestBody.getAmount() / 100)
                .mbCurrency(Currency.EUR.name())
                .status(ConsulStepDefs.consulProperties.extended.statusCodes.scheduled)
                .amount((double) DepositRequestStepDefs.requestBody.getAmount() / 100)
                .currency(Currency.EUR.name()).build();
    }

    @Given("deposit callback request params with status is unknown")
    public void requestParamsStatusUnknown() {
        requestParams = DepositCallbackRequest.RequestParams.builder()
                .payToEmail(ConsulStepDefs.consulProperties.extended.api.eur.username )
                .payFromEmail(DepositRequestStepDefs.request.getResponseBody().getData().getUrlParameters().getParameters().getPayFromEmail())
                .merchantId("213213")
                .customerId("2123")
                .transactionId(DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString())
                .mbAmount((double) DepositRequestStepDefs.requestBody.getAmount() / 100)
                .mbCurrency(Currency.EUR.name())
                .status(9)
                .amount((double) DepositRequestStepDefs.requestBody.getAmount() / 100)
                .currency(Currency.EUR.name()).build();
    }

    @Given("deposit callback request params with incorrect transaction id")
    public void requestParamsIncorrectTransactionId() {
        requestParams = DepositCallbackRequest.RequestParams.builder()
                .payToEmail(ConsulStepDefs.consulProperties.extended.api.eur.username )
                .payFromEmail(DepositRequestStepDefs.request.getResponseBody().getData().getUrlParameters().getParameters().getPayFromEmail())
                .merchantId("213213")
                .customerId("2123")
                .transactionId("999999999")
                .mbAmount((double) DepositRequestStepDefs.requestBody.getAmount() / 100)
                .mbCurrency(Currency.EUR.name())
                .status(9)
                .amount((double) DepositRequestStepDefs.requestBody.getAmount() / 100)
                .currency(Currency.EUR.name()).build();
    }

    @When("send deposit callback request")
    public void sendRequest() {
        request.request(requestParams, ConsulStepDefs.consulProperties.extended.api.eur.secretWord).deserialize();
    }

    @Then("deposit callback response statusCode={int}, code={int}, message={string}")
    public void checkResponse(int statusCode, int code, String message) {
        SoftAssert softAssert = new SoftAssert();
        softAssert.assertEquals(request.getResponse().getStatusCode(), statusCode, "Incorrect status code!");
        softAssert.assertEquals((int) request.getResponseBody().getCode(), code, "Incorrect code");
        softAssert.assertEquals(request.getResponseBody().getMessage(), message, "Incorrect message!");
        softAssert.assertAll();
    }
}