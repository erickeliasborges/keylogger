package com.example.keylogger;

import com.example.generic.crud.GenericResource;

import javax.enterprise.context.RequestScoped;
import javax.ws.rs.Path;
import javax.ws.rs.core.Response;

@RequestScoped
@Path("keylogger")
public class KeyLoggerResource extends GenericResource<KeyLogger, Long, KeyLoggerService> {

    @Override
    public Response save(KeyLogger genericClass) {
        return super.save(genericClass);
    }

    @Override
    public Response update(KeyLogger genericClass) {
        return super.update(genericClass);
    }
}
