package Server.API;

import Server.Errors.ApplicationExceptions;
import Server.Errors.GlobalExceptionHandler;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import io.vavr.control.Try;

import java.io.InputStream;
import java.io.OutputStream;

public abstract class Handler {
    private final ObjectMapper ObjectMapper;
    private final GlobalExceptionHandler GlobalExceptionHandler;
    private final String RequestMethodAllowed;

    public Handler(String RequestMethodAllowed, ObjectMapper ObjectMapper, GlobalExceptionHandler GlobalExceptionHandler) {
        this.RequestMethodAllowed = RequestMethodAllowed;
        this.ObjectMapper = ObjectMapper;
        this.GlobalExceptionHandler = GlobalExceptionHandler;
    }

    public void Handle(HttpExchange exchange) {
        Try.run(() -> Execute(exchange)).onFailure(thr -> GlobalExceptionHandler.handle(thr, exchange));
    }

    protected void Execute(HttpExchange exchange) throws Exception {
        byte[] response;
        if (RequestMethodAllowed.equals(exchange.getRequestMethod())) {
            ResponseEntity e = DoPost(exchange.getRequestBody());
            exchange.getResponseHeaders().putAll(e.GetHeaders());
            exchange.sendResponseHeaders(e.GetStatusCode(), 0);
            response = WriteResponse(e.GetBody());
        } else {
            throw ApplicationExceptions.methodNotAllowed("Method " + exchange.getRequestMethod() + " is not allowed for " + exchange.getRequestURI()).get();
        }

        OutputStream os = exchange.getResponseBody();
        os.write(response);
        os.close();
    }

    protected abstract <T> T DoPost(InputStream inputStream) throws Exception;

    protected <T> T ReadRequest(InputStream is, Class<T> type) {
        return Try.of(() -> ObjectMapper.readValue(is, type)).getOrElseThrow(ApplicationExceptions.invalidRequest());
    }

    protected <T> byte[] WriteResponse(T response) {
        return Try.of(() -> ObjectMapper.writeValueAsBytes(response)).getOrElseThrow(ApplicationExceptions.invalidRequest());
    }

    protected static Headers GetHeaders(String key, String value) {
        Headers headers = new Headers();
        headers.set(key, value);
        return headers;
    }
}
