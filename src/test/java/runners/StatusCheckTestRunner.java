package runners;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

@CucumberOptions(
        features = {"src/test/java/features/status_check.feature"},
        glue = "step_defs",
        plugin = {"pretty", "json:target/cucumber-report.json"}
)
public class StatusCheckTestRunner extends AbstractTestNGCucumberTests {
}