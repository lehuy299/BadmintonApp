package Server.API.Users.Handler;

import Database.Request.GetAllCenterInCitySql;
import Server.API.Constants;
import Server.API.Handler;
import Server.API.ResponseEntity;
import Server.API.StatusCode;
import Server.API.Users.Request.GetAllCenterInCityRequest;
import Server.API.Users.Response.GetAllCenterInCityResponse;

import java.io.InputStream;

public class GetAllCenterInCityHandler extends Handler {
    public GetAllCenterInCityHandler(String MethodAllowed, com.fasterxml.jackson.databind.ObjectMapper ObjectMapper, Server.Errors.GlobalExceptionHandler GlobalExceptionHandler)  {
        super(MethodAllowed, ObjectMapper, GlobalExceptionHandler);
    }

    @Override
    protected ResponseEntity<GetAllCenterInCityResponse> DoPost(InputStream InputStream) {
        GetAllCenterInCityRequest GetAllCenterInCityRequest = ReadRequest(InputStream, GetAllCenterInCityRequest.class);

        GetAllCenterInCityResponse GetAllCenterInCityResponse = GetAllCenterInCitySql.Get(GetAllCenterInCityRequest);

        return new ResponseEntity<>(StatusCode.OK, GetHeaders(Constants.ContentType, Constants.ApplicationJSON), GetAllCenterInCityResponse);
    }
}
