package mocking;

import com.github.tomakehurst.wiremock.client.WireMock;
import com.github.tomakehurst.wiremock.http.Body;
import com.github.tomakehurst.wiremock.matching.UrlPattern;
import configuration.Configuration;
import ge.singular.common.mocking.BaseMock;


import static com.github.tomakehurst.wiremock.client.WireMock.*;

public class IntegrationMock extends BaseMock {
    public IntegrationMock(String host, int port) {
        super(host, port);
    }

    public void examplePostRequestUpdate(int statusCode, String responseBody) {
        UrlPattern urlPattern = WireMock.urlPathEqualTo("/template/example/post");
        updateStub(Configuration.integrationConfig.getStubs().getExamplePostRequest(),
                post(urlPattern)
                        .withName("Template - Example provider POST request")
                        .willReturn(status(statusCode).withResponseBody(new Body(responseBody))));
    }

    public void exampleGetRequestUpdate(int statusCode, String responseBody) {
        UrlPattern urlPattern = WireMock.urlPathEqualTo("/template/example/get");
        updateStub(Configuration.integrationConfig.getStubs().getExampleGetRequest(),
                get(urlPattern)
                        .withName("Template - Example provider GET request")
                        .willReturn(status(statusCode).withResponseBody(new Body(responseBody))));
    }
}
