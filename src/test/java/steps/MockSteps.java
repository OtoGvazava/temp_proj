package steps;

import configuration.Configuration;
import io.cucumber.java.en.Given;
import mocking.IntegrationMock;

public class MockSteps extends BaseSteps {
    private final IntegrationMock integrationMock;

    @Override
    public void reset() {
    }

    public MockSteps() {
        integrationMock = new IntegrationMock(Configuration.commonConfig.getMock().getHost(),
                Configuration.commonConfig.getMock().getPort());
    }

    @Given("provider example post request returns success response")
    public void examplePostRequestSuccessResponse() {
        integrationMock.examplePostRequestUpdate(200, """
                {
                "status": "SUCCESS"
                }
                """);
    }

    @Given("provider example post request returns fail response")
    public void examplePostRequestFailResponse() {
        integrationMock.examplePostRequestUpdate(200, """
                {
                "status": "FAIL"
                }
                """);
    }

    @Given("provider example get request returns success response")
    public void exampleGetRequestSuccessResponse() {
        integrationMock.exampleGetRequestUpdate(200, """
                {
                "status": "SUCCESS"
                }
                """);
    }
}
