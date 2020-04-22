package Server.API.Users.Response;

import Struct.Booking;

import java.util.List;

public class GetCourtBookingResponse {
    public GetCourtBookingResponse(int ResultCode) { this.ResultCode = ResultCode; }
    public int ResultCode;
    public List<Booking> Bookings;
}
