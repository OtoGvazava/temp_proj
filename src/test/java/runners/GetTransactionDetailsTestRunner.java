package runners;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

@CucumberOptions(
        features = {"src/test/java/features/get_transaction_details.feature"},
        glue = "step_defs",
        plugin = {"pretty", "json:target/cucumber-report.json"}
)
public class GetTransactionDetailsTestRunner extends AbstractTestNGCucumberTests {
}