package configuration;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;
import lombok.Data;

@Data
public class CommonConfig {
    @SerializedName("mock")
    @Expose
    private Mock mock;
    @SerializedName("db")
    @Expose
    private Db db;
    @SerializedName("core_integration_api")
    @Expose
    private String coreIntegrationApi;
    @SerializedName("auth_proxy_api")
    @Expose
    private String authProxyApi;
    @SerializedName("proxy_client_ip")
    @Expose
    private String proxyClientIp;
    @SerializedName("proxy_auth_secret")
    @Expose
    private String proxyAuthSecret;
    @SerializedName("origin.referrer")
    @Expose
    private String originReferrer;

    @Data
    public static class Mock {
        @SerializedName("host")
        @Expose
        private String host;
        @SerializedName("port")
        @Expose
        private int port;
    }

    @Data
    public static class Db {
        @SerializedName("core")
        @Expose
        private DbModel core;
        @SerializedName("rule_engine")
        @Expose
        private DbModel ruleEngine;
        @SerializedName("sis_payments")
        @Expose
        private DbModel sisPayments;

        @Data
        public static class DbModel {
            @SerializedName("host")
            @Expose
            private String host;
            @SerializedName("port")
            @Expose
            private String port;
            @SerializedName("username")
            @Expose
            private String username;
            @SerializedName("password")
            @Expose
            private String password;
        }
    }
}