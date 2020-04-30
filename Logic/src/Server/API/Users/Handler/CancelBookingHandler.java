package Server.API.Users.Handler;

import Database.Request.CancelBookingSql;
import Server.API.Constants;
import Server.API.Handler;
import Server.API.ResponseEntity;
import Server.API.StatusCode;
import Server.API.Users.Request.CancelBookingRequest;
import Server.API.Users.Response.CancelBookingResponse;

import java.io.InputStream;

public class CancelBookingHandler extends Handler {
    public CancelBookingHandler(String MethodAllowed, com.fasterxml.jackson.databind.ObjectMapper ObjectMapper, Server.Errors.GlobalExceptionHandler GlobalExceptionHandler)  {
        super(MethodAllowed, ObjectMapper, GlobalExceptionHandler);
    }

    @Override
    protected ResponseEntity<CancelBookingResponse> DoPost(InputStream InputStream) {
        CancelBookingRequest CancelBookingRequest = ReadRequest(InputStream, CancelBookingRequest.class);

        CancelBookingResponse CancelBookingResponse = CancelBookingSql.Post(CancelBookingRequest);

        return new ResponseEntity<>(StatusCode.OK, GetHeaders(Constants.ContentType, Constants.ApplicationJSON), CancelBookingResponse);
    }
}