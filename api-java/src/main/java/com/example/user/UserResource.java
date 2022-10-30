package com.example.user;

import com.example.generic.crud.GenericResource;

import javax.enterprise.context.RequestScoped;
import javax.ws.rs.Path;

@RequestScoped
@Path("user")
public class UserResource extends GenericResource<User, Long, UserService> {

}
