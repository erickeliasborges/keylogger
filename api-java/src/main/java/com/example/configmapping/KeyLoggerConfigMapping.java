package com.example.configmapping;

import io.smallrye.config.ConfigMapping;

@ConfigMapping(prefix = "keylogger")
public interface KeyLoggerConfigMapping {

    String dns();

}
