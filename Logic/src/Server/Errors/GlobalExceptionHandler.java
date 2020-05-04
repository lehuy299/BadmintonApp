package Server.Errors;

import Server.API.Constants;
import Server.API.ErrorResponse;
import Server.API.StatusCode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.OutputStream;

public class GlobalExceptionHandler {
    private final ObjectMapper objectMapper;

    public GlobalExceptionHandler(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    public void handle(Throwable throwable, HttpExchange exchange) {
        try {
            throwable.printStackTrace();
            exchange.getResponseHeaders().set(Constants.ContentType, Constants.ApplicationJSON);
            ErrorResponse response = getErrorResponse(throwable, exchange);
            OutputStream responseBody = exchange.getResponseBody();
            responseBody.write(objectMapper.writeValueAsBytes(response));
            responseBody.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private ErrorResponse getErrorResponse(Throwable throwable, HttpExchange exchange) throws IOException {
        ErrorResponse Response;
        if (throwable instanceof InvalidRequestException) {
            InvalidRequestException exc = (InvalidRequestException) throwable;
            Response = new ErrorResponse(exc.code, exc.getMessage());
            exchange.sendResponseHeaders(StatusCode.BadRequest, 0);
        } else if (throwable instanceof ResourceNotFoundException) {
            ResourceNotFoundException exc = (ResourceNotFoundException) throwable;
            Response = new ErrorResponse(exc.code, exc.getMessage());
            exchange.sendResponseHeaders(StatusCode.ResourceNotFound, 0);
        } else if (throwable instanceof MethodNotAllowedException) {
            MethodNotAllowedException exc = (MethodNotAllowedException) throwable;
            Response = new ErrorResponse(exc.code, exc.getMessage());
            exchange.sendResponseHeaders(StatusCode.MethodNotAllowed, 0);
        } else {
            Response = new ErrorResponse(StatusCode.InternalServerError, throwable.getMessage());
            exchange.sendResponseHeaders(StatusCode.InternalServerError, 0);
        }
        return Response;
    }
}