package Server.API.Users.Response;

import Struct.City;

import java.util.ArrayList;

public class GetAllCityResponse {
    public GetAllCityResponse(int ResultCode) { this.ResultCode = ResultCode; this.Cities = new ArrayList<>();}
    public int ResultCode;
    public ArrayList<City> Cities;
}
