package Server.API.Users.Response;

import Struct.Center;

import java.util.ArrayList;

public class GetAllCenterInCityResponse {
    public GetAllCenterInCityResponse(int ResultCode) { this.ResultCode = ResultCode; this.Centers = new ArrayList<>(); }
    public int ResultCode;
    public ArrayList<Center> Centers;
}
