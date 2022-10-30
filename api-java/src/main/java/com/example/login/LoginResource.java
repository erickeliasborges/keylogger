package com.example.login;

import com.example.reponses.GenericResponse;
import com.example.reponses.TokenResponse;

import javax.inject.Inject;
import javax.validation.Valid;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Response;
import java.util.Optional;

@Path("login")
public class LoginResource {

    @Inject
    LoginService loginResource;

    @POST
    public Response logar(@Valid LoginRequest loginRequest) throws Exception {

        Optional<TokenResponse> tokenResponse = loginResource.logar(loginRequest);
        if (tokenResponse.isPresent())
            return Response.status(Response.Status.OK).entity(tokenResponse.get()).build();
        else
            return Response
                    .status(Response.Status.UNAUTHORIZED)
                    .entity(GenericResponse.getGenericResponse("Usuário ou senha inválidos.", Response.Status.UNAUTHORIZED.getStatusCode()))
                    .build();

    }

}
