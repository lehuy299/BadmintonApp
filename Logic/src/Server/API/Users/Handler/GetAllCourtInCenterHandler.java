package Server.API.Users.Handler;

import Database.Request.GetAllCourtInCenterSql;
import Server.API.Constants;
import Server.API.Handler;
import Server.API.ResponseEntity;
import Server.API.StatusCode;
import Server.API.Users.Request.GetAllCourtInCenterRequest;
import Server.API.Users.Response.GetAllCourtInCenterResponse;

import java.io.InputStream;

public class GetAllCourtInCenterHandler extends Handler {
    public GetAllCourtInCenterHandler(String MethodAllowed, com.fasterxml.jackson.databind.ObjectMapper ObjectMapper, Server.Errors.GlobalExceptionHandler GlobalExceptionHandler) {
        super(MethodAllowed, ObjectMapper, GlobalExceptionHandler);
    }

    @Override
    protected ResponseEntity<GetAllCourtInCenterResponse> DoPost(InputStream InputStream) {
        GetAllCourtInCenterRequest GetAllCourtInCenterRequest = ReadRequest(InputStream, GetAllCourtInCenterRequest.class);

        GetAllCourtInCenterResponse GetAllCourtInCenterResponse = GetAllCourtInCenterSql.Get(GetAllCourtInCenterRequest);

        return new ResponseEntity<>(StatusCode.OK, GetHeaders(Constants.ContentType, Constants.ApplicationJSON), GetAllCourtInCenterResponse);
    }
}
