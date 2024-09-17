package steps;

import io.cucumber.java.After;

public abstract class BaseStepDefs {
    @After
    public abstract void reset();
}
