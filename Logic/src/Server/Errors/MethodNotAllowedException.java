package Server.Errors;

class MethodNotAllowedException extends ApplicationException {
    MethodNotAllowedException(int Code, String Message) {
        super(Code, Message);
    }
}
