package Server.API.Users.Handler;

import Database.Request.GetPlayerInfoSql;
import Server.API.Constants;
import Server.API.Handler;
import Server.API.ResponseEntity;
import Server.API.StatusCode;
import Server.API.Users.Request.GetPlayerInfoRequest;
import Server.API.Users.Response.GetPlayerInfoResponse;

import java.io.InputStream;

public class GetPlayerInfoHandler extends Handler {
    public GetPlayerInfoHandler(String MethodAllowed, com.fasterxml.jackson.databind.ObjectMapper ObjectMapper, Server.Errors.GlobalExceptionHandler GlobalExceptionHandler) {
        super(MethodAllowed, ObjectMapper, GlobalExceptionHandler);
    }

    @Override
    protected ResponseEntity<GetPlayerInfoResponse> DoPost(InputStream InputStream) {
        GetPlayerInfoRequest GetPlayerInfoRequest = ReadRequest(InputStream, GetPlayerInfoRequest.class);

        GetPlayerInfoResponse GetPlayerInfoResponse = GetPlayerInfoSql.Get(GetPlayerInfoRequest);

        return new ResponseEntity<>(StatusCode.OK, GetHeaders(Constants.ContentType, Constants.ApplicationJSON), GetPlayerInfoResponse);
    }
}
