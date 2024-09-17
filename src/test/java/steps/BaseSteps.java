package steps;

import io.cucumber.java.After;

public abstract class BaseSteps {
    @After
    public abstract void reset();
}
