package steps;

import configuration.Configuration;
import ge.singular.payment.api.rest.integration.payment.GetTransactionDetailsRequest;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;

public class GetTransactionDetailsStepDefs extends BaseStepDefs {
    public static GetTransactionDetailsRequest request;
    public static GetTransactionDetailsRequest.RequestBody requestBody;

    static {
        request = new GetTransactionDetailsRequest(Configuration.INTEGRATION_HOST);
    }

    @Override
    public void reset() {
        request = null;
        requestBody = null;
    }

    @Given("get transaction details request body")
    public void getRequestBody() {
        requestBody = GetTransactionDetailsRequest.RequestBody.builder()
                .transactionId(DepositRequestStepDefs.request.getResponseBody().getData().getTransactionId().toString())
                .userId(OtherStepDefs.userId).build();
    }

    @When("send get transaction request")
    public void sendRequest() {
        request.request(requestBody, Configuration.PROXY_CLIENT_IP, Configuration.PROXY_AUTH_SECRET);
    }
}
