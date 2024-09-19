package runners;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

@CucumberOptions(
        features = {"src/test/java/features/with_provider_real_service.feature"},
        glue = "step_defs",
        plugin = {"pretty", "json:target/cucumber-report.json"}
)
public class WithProviderRealServiceTestRunner extends AbstractTestNGCucumberTests {
}