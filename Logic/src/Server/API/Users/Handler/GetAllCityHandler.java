package Server.API.Users.Handler;

import Database.Request.GetAllCitySql;
import Server.API.Constants;
import Server.API.Handler;
import Server.API.ResponseEntity;
import Server.API.StatusCode;
import Server.API.Users.Response.GetAllCityResponse;

import java.io.InputStream;

public class GetAllCityHandler extends Handler {
    public GetAllCityHandler(String MethodAllowed, com.fasterxml.jackson.databind.ObjectMapper ObjectMapper, Server.Errors.GlobalExceptionHandler GlobalExceptionHandler)  {
        super(MethodAllowed, ObjectMapper, GlobalExceptionHandler);
    }

    @Override
    protected ResponseEntity<GetAllCityResponse> DoPost(InputStream InputStream) {
        GetAllCityResponse GetAllCityResponse = GetAllCitySql.Get();

        return new ResponseEntity<>(StatusCode.OK, GetHeaders(Constants.ContentType, Constants.ApplicationJSON), GetAllCityResponse);
    }
}
