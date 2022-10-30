package com.example.keylogger;

import com.example.generic.crud.GenericService;
import com.example.reponses.GenericResponse;
import com.example.request.http.HttpRequestContext;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import java.time.LocalDateTime;
import java.util.Objects;

@RequestScoped
public class KeyLoggerService extends GenericService<KeyLogger, Long, KeyLoggerRepository> {

    @Inject
    HttpRequestContext httpRequestContext;

    @Override
    public GenericResponse save(KeyLogger entity) {
        setFixedData(entity);
        return super.save(entity);
    }

    @Override
    public GenericResponse update(KeyLogger entity) {
        setFixedData(entity);
        return super.update(entity);
    }

    private void setFixedData(KeyLogger keyLogger) {
        setInclusionDate(keyLogger);
        setFromHostAddress(keyLogger);
        setFromHostName(keyLogger);
    }

    private void setInclusionDate(KeyLogger keyLogger) {
        if (Objects.isNull(keyLogger.getInclusionDate()))
            keyLogger.setInclusionDate(LocalDateTime.now());
    }

    private void setFromHostAddress(KeyLogger keyLogger) {
        keyLogger.setFromHostAddress(httpRequestContext.getHttpServerRequest().remoteAddress().toString());
    }

    private void setFromHostName(KeyLogger keyLogger) {
        keyLogger.setFromHostName(httpRequestContext.getHttpServerRequest().remoteAddress().hostName());
    }

}
