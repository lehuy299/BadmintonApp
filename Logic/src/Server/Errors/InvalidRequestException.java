package Server.Errors;

class InvalidRequestException extends ApplicationException {
    public InvalidRequestException(int code, String message) {
        super(code, message);
    }
}