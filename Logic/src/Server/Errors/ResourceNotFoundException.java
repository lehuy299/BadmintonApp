package Server.Errors;

class ResourceNotFoundException extends ApplicationException {
    ResourceNotFoundException(int Code, String Message) {
        super(Code, Message);
    }
}
