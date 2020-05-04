package Server;

import Server.Errors.GlobalExceptionHandler;
import com.fasterxml.jackson.databind.ObjectMapper;

class Configuration {
    public static final ObjectMapper ObjectMapper = new ObjectMapper();
    public static final GlobalExceptionHandler GlobalExceptionHandler = new GlobalExceptionHandler(ObjectMapper);
}
