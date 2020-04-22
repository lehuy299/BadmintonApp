package Server.API.Users.Handler;

import Database.MySqlRequest;
import Server.API.Constants;
import Server.API.Handler;
import Server.API.ResponseEntity;
import Server.API.StatusCode;
import Server.API.Users.Request.CreateBookingRequest;
import Server.API.Users.Response.CreateBookingResponse;
import Server.Errors.GlobalExceptionHandler;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.InputStream;

public class CreateBookingHandler extends Handler {
    public CreateBookingHandler(String MethodAllowed, ObjectMapper ObjectMapper, GlobalExceptionHandler GlobalExceptionHandler)  {
        super(MethodAllowed, ObjectMapper, GlobalExceptionHandler);
    }

    @Override
    protected ResponseEntity<CreateBookingResponse> DoPost(InputStream InputStream) {
        CreateBookingRequest CreateBookingRequest = ReadRequest(InputStream, CreateBookingRequest.class);

        CreateBookingResponse CreateBookingResponse = MySqlRequest.CreateBooking(CreateBookingRequest);

        return new ResponseEntity<>(StatusCode.OK, GetHeaders(Constants.ContentType, Constants.ApplicationJSON), CreateBookingResponse);
    }
}