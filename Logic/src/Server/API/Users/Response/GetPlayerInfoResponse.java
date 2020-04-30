package Server.API.Users.Response;

public class GetPlayerInfoResponse {
    public GetPlayerInfoResponse(int ResultCode) { this.ResultCode = ResultCode; }
    public int ResultCode;
    public String PlayerID;
    public String PlayerName;
    public String PlayerEmail;
}
