package Server.Errors;

import lombok.Getter;

@Getter
public class ApplicationException extends RuntimeException {

    public final int code;

    ApplicationException(int code, String message) {
        super(message);
        this.code = code;
    }
}