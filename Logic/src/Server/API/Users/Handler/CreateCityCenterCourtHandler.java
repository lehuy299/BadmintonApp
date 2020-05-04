package Server.API.Users.Handler;

import Database.Request.CreateCityCenterCourtSql;
import Server.API.Constants;
import Server.API.Handler;
import Server.API.ResponseEntity;
import Server.API.StatusCode;
import Server.API.Users.Request.CreateCityCenterCourtRequest;
import Server.API.Users.Response.CreateCityCenterCourtResponse;
import Server.Errors.GlobalExceptionHandler;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.InputStream;

public class CreateCityCenterCourtHandler extends Handler {
    public CreateCityCenterCourtHandler(String MethodAllowed, ObjectMapper ObjectMapper, GlobalExceptionHandler GlobalExceptionHandler)  {
        super(MethodAllowed, ObjectMapper, GlobalExceptionHandler);
    }

    @Override
    protected ResponseEntity<CreateCityCenterCourtResponse> DoPost(InputStream InputStream) {
        CreateCityCenterCourtRequest CreateCityCenterCourtRequest = ReadRequest(InputStream, CreateCityCenterCourtRequest.class);

        CreateCityCenterCourtResponse CreateCityCenterCourtResponse = CreateCityCenterCourtSql.Create(CreateCityCenterCourtRequest);

        return new ResponseEntity<>(StatusCode.OK, GetHeaders(Constants.ContentType, Constants.ApplicationJSON), CreateCityCenterCourtResponse);
    }
}
