package com.example.user;

import com.example.generic.crud.GenericRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends GenericRepository<User, Long> {

    List<User> findByUsername(String username);

}
