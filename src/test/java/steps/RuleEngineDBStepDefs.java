package steps;

import configuration.Configuration;
import ge.singular.payment.db.RuleEngineDB;
import io.cucumber.java.en.And;

public class RuleEngineDBStepDefs extends BaseStepDefs {
    private final RuleEngineDB ruleEngineDB;

    public RuleEngineDBStepDefs() {
        ruleEngineDB = new RuleEngineDB(Configuration.commonConfig.getDb().getRuleEngine().getHost() + ":" + Configuration.commonConfig.getDb().getRuleEngine().getPort(),
                Configuration.commonConfig.getDb().getRuleEngine().getUsername(), Configuration.commonConfig.getDb().getRuleEngine().getPassword());
    }

    @Override
    public void reset() {
    }

    @And("ruleEngine validation passed")
    public void updateRuleActionAsPassed() {
        ruleEngineDB.updateDefaultRule("[{\"id\": 1, \"value\": null}]",
                Configuration.integrationConfig.getProviderId(), Configuration.integrationConfig.getServiceId(), 1);
        ruleEngineDB.deleteRules(Configuration.integrationConfig.getProviderId(), Configuration.integrationConfig.getServiceId());
    }

    @And("ruleEngine validation passed with charge")
    public void updateRuleActionAsPassedCharged() {
        ruleEngineDB.updateDefaultRule("[{\"id\": 1, \"value\": null}, {\"id\": 4, \"value\": 0.1}]",
                Configuration.integrationConfig.getProviderId(), Configuration.integrationConfig.getServiceId(), 1);
        ruleEngineDB.deleteRules(Configuration.integrationConfig.getProviderId(), Configuration.integrationConfig.getServiceId());
    }

    @And("ruleEngine validation rejected")
    public void updateRuleActionAsRejected() {
        ruleEngineDB.updateDefaultRule("[{\"id\": 2, \"value\": null}]",
                Configuration.integrationConfig.getProviderId(), Configuration.integrationConfig.getServiceId(), 1);
        ruleEngineDB.deleteRules(Configuration.integrationConfig.getProviderId(), Configuration.integrationConfig.getServiceId());
    }

    @And("ruleEngine validation pending")
    public void updateRuleActionAsPending() {
        ruleEngineDB.updateDefaultRule("[{\"id\": 3, \"value\": null}]",
                Configuration.integrationConfig.getProviderId(), Configuration.integrationConfig.getServiceId(), 1);
        ruleEngineDB.deleteRules(Configuration.integrationConfig.getProviderId(), Configuration.integrationConfig.getServiceId());
    }
}
