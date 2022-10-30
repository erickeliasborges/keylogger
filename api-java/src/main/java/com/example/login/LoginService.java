package com.example.login;

import com.example.reponses.TokenResponse;
import com.example.roles.RoleEmailType;
import com.example.user.User;
import com.example.utils.TokenUtils;
import com.example.user.UserRepository;
import org.wildfly.security.password.Password;
import org.wildfly.security.password.PasswordFactory;
import org.wildfly.security.password.interfaces.BCryptPassword;
import org.wildfly.security.password.util.ModularCrypt;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import java.util.Optional;

@RequestScoped
public class LoginService {

    @Inject
    UserRepository userRepository;

    @Inject
    TokenUtils tokenUtils;

    public Optional<TokenResponse> logar(LoginRequest loginRequest) throws Exception {
        Optional<TokenResponse> token = Optional.empty();

        Optional<User> userOptional = userRepository.findByUsername(loginRequest.getUsername()).stream().findFirst();

        Boolean gerarToken = ((userOptional.isPresent()) && (verifyPassword(loginRequest.getPassword(), userOptional.get().getPassword())));
        if (gerarToken)
            token = Optional.of(tokenUtils.generateToken(userOptional.get().getId().toString(), RoleEmailType.ADMIN));

        return token;
    }

    public boolean verifyPassword(String originalPwd, String encryptedPwd) throws Exception {
        // convert encrypted password string to a password key
        Password rawPassword = ModularCrypt.decode(encryptedPwd);

        // create the password factory based on the bcrypt algorithm
        PasswordFactory factory = PasswordFactory.getInstance(BCryptPassword.ALGORITHM_BCRYPT);

        // create encrypted password based on stored string
        BCryptPassword restored = (BCryptPassword) factory.translate(rawPassword);

        // verify restored password against original
        return factory.verify(restored, originalPwd.toCharArray());
    }

}
