package Server.API;

public class ErrorResponse {
    public ErrorResponse(int Code, String Message) { this.ResultCode = Code; this.Message = Message; }

    public int ResultCode;
    public String Message;
}