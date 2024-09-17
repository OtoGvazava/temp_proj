package runners;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

@CucumberOptions(
        features = {"src/test/java/features/skrill_withdraw.feature"},
        glue = {"step_defs", "hooks.pay_account_exists"},
        plugin = {"pretty", "json:target/cucumber-report.json"}
)
public class WithdrawTestRunner extends AbstractTestNGCucumberTests {
}