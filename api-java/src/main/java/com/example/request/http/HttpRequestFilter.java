package com.example.request.http;

import io.vertx.core.http.HttpServerRequest;

import javax.inject.Inject;
import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerRequestFilter;
import javax.ws.rs.core.Context;
import javax.ws.rs.ext.Provider;
import java.io.IOException;

@Provider
public class HttpRequestFilter implements ContainerRequestFilter {

    @Context
    HttpServerRequest httpServerRequest;

    @Inject
    HttpRequestContext httpRequestContext;

    @Override
    public void filter(ContainerRequestContext containerRequestContext) throws IOException {
        httpRequestContext.setHttpServerRequest(httpServerRequest);
    }

}
