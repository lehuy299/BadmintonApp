package Server.API.Users.Handler;

import Database.Request.CreatePlayerSql;
import Server.API.Constants;
import Server.API.Handler;
import Server.API.ResponseEntity;
import Server.API.StatusCode;
import Server.API.Users.Request.CreatePlayerRequest;
import Server.API.Users.Response.CreatePlayerResponse;
import Server.Errors.GlobalExceptionHandler;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.InputStream;

public class CreatePlayerHandler extends Handler {
    public CreatePlayerHandler(String MethodAllowed, ObjectMapper ObjectMapper, GlobalExceptionHandler GlobalExceptionHandler)  {
        super(MethodAllowed, ObjectMapper, GlobalExceptionHandler);
    }

    @Override
    protected ResponseEntity<CreatePlayerResponse> DoPost(InputStream InputStream) {
        CreatePlayerRequest CreatePlayerRequest = ReadRequest(InputStream, CreatePlayerRequest.class);

        CreatePlayerResponse CreatePlayerResponse = CreatePlayerSql.Create(CreatePlayerRequest);

        return new ResponseEntity<>(StatusCode.OK, GetHeaders(Constants.ContentType, Constants.ApplicationJSON), CreatePlayerResponse);
    }
}
