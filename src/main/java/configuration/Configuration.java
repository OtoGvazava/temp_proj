package configuration;

import ge.singular.common.utils.ConfigReader;
import ge.singular.common.utils.ConsulReader;

public interface Configuration {
    ConfigReader localConfig = System.getProperty("ENV") != null
            && System.getProperty("ENV").equalsIgnoreCase("DEV")
            ? ConfigReader.read("src/test/resources/properties/dev.properties")
            : ConfigReader.read("src/test/resources/properties/qa.properties");

    ConsulReader remoteConfig = new ConsulReader(localConfig.getProperty("consul.host"));

    CommonConfig commonConfig = remoteConfig.read("core-platform-qa/payments/common", CommonConfig.class);

    IntegrationConfig integrationConfig = remoteConfig.read("core-platform-qa/payments/integrations/" + localConfig.getProperty("service.name"), IntegrationConfig.class);
    ServiceConfig serviceConfig = remoteConfig.read("core-platform/integrations/" + localConfig.getProperty("service.name"), ServiceConfig.class);
}