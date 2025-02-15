package runners;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

@CucumberOptions(
        features = {"src/test/java/features/deposit.feature"},
        glue = "step_defs",
        plugin = {"pretty", "json:target/cucumber-report.json"}
)
public class DepositTestRunner extends AbstractTestNGCucumberTests {
}