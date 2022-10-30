package com.example.request.http;

import io.vertx.core.http.HttpServerRequest;
import lombok.Getter;
import lombok.Setter;

import javax.enterprise.context.RequestScoped;

@Getter
@Setter
@RequestScoped
public class HttpRequestContext {

    private HttpServerRequest httpServerRequest;

}
