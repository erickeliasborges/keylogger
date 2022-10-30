package com.example.configmapping;

import io.smallrye.config.ConfigMapping;
import io.smallrye.config.WithName;

import java.util.Map;

@ConfigMapping(prefix = "jwt-keylogger")
public interface JwtKeyLoggerConfigMapping {

    Long duration();

    Map<String, String> password();

    @WithName("publickey-location")
    String publickey_location();

    @WithName("privatekey-location")
    String privatekey_location();

}
