package configuration;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;
import lombok.Data;

@Data
public class ServiceConfig {
    @SerializedName("ProviderId")
    @Expose
    private String providerId;
    @SerializedName("ProviderSecret")
    @Expose
    private String providerSecret;
    @SerializedName("Job")
    @Expose
    private Job job;

    @Data
    public static class Job {
        @SerializedName("Secret")
        @Expose
        private String secret;
    }
}
