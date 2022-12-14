package com.example.user;

import com.example.generic.crud.GenericService;
import com.example.reponses.GenericResponse;
import io.quarkus.elytron.security.common.BcryptUtil;

import javax.enterprise.context.RequestScoped;

@RequestScoped
public class UserService extends GenericService<User, Long, UserRepository> {

    @Override
    public GenericResponse save(User entity) {
        entity.setPassword(BcryptUtil.bcryptHash(entity.getPassword()));
        return super.save(entity);
    }
}
