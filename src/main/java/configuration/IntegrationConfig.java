package configuration;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;
import io.cucumber.java.sl.In;
import lombok.Data;

import java.util.UUID;

@Data
public class IntegrationConfig {
    @SerializedName("host")
    @Expose
    private String host;
    @SerializedName("consul_path")
    @Expose
    private String consulPath;
    @SerializedName("user_id")
    @Expose
    private Integer userId;
    @SerializedName("service_id")
    @Expose
    private Integer serviceId;
    @SerializedName("provider_id")
    @Expose
    private Integer providerId;
    @SerializedName("provider_label")
    @Expose
    private String providerLabel;
    @SerializedName("user_name")
    @Expose
    private String userName;
    @SerializedName("user_password")
    @Expose
    private String userPassword;
    @SerializedName("service_name")
    @Expose
    private String serviceName;
    @SerializedName("sis_provider_secret")
    @Expose
    private String sisProviderSecret;
    @SerializedName("sis_provider_id")
    @Expose
    private String sisProviderId;
    @SerializedName("stubs")
    @Expose
    private Stubs stubs;

    @Data
    public static class Stubs {
        @SerializedName("examplePostRequest")
        @Expose
        private UUID examplePostRequest;
        @SerializedName("exampleGetRequest")
        @Expose
        private UUID exampleGetRequest;
    }
}