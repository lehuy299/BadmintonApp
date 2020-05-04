package Server.API.Users.Handler;

import Database.Request.CreateCitySql;
import Server.API.Constants;
import Server.API.Handler;
import Server.API.ResponseEntity;
import Server.API.StatusCode;
import Server.API.Users.Request.CreateCityRequest;
import Server.API.Users.Response.CreateCityResponse;
import Server.Errors.GlobalExceptionHandler;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.InputStream;

public class CreateCityHandler extends Handler {
    public CreateCityHandler(String MethodAllowed, ObjectMapper ObjectMapper, GlobalExceptionHandler GlobalExceptionHandler)  {
        super(MethodAllowed, ObjectMapper, GlobalExceptionHandler);
    }

    @Override
    protected ResponseEntity<CreateCityResponse> DoPost(InputStream InputStream) {
        CreateCityRequest CreateCityRequest = ReadRequest(InputStream, CreateCityRequest.class);

        CreateCityResponse CreateCityResponse = CreateCitySql.Create(CreateCityRequest);

        return new ResponseEntity<>(StatusCode.OK, GetHeaders(Constants.ContentType, Constants.ApplicationJSON), CreateCityResponse);
    }
}
