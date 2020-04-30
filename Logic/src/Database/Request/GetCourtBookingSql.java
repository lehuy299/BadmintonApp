package Database.Request;

import Database.MySqlConnection;
import Server.API.Users.Request.GetCourtBookingRequest;
import Server.API.Users.Response.GetCourtBookingResponse;
import Struct.Booking;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

public class GetCourtBookingSql {
    public static GetCourtBookingResponse Get(GetCourtBookingRequest Request)
    {
        try {
            CallableStatement Statement = MySqlConnection.GetProcedureStatement("{Call getCourtBooking(?,?,?,?,?)}");
            Statement.setDate(1, Request.BookingDay);
            Statement.setString(2, Request.CourtID);
            Statement.setString(3, Request.CenterID);
            Statement.setString(4, Request.CityID);
            Statement.registerOutParameter(5, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(5);

            GetCourtBookingResponse Response = new GetCourtBookingResponse(ResultCode);

            ResultSet Result = Statement.getResultSet();
            if (Result.getRow() > 0)
            {
                while (Result.next()) {
                    Booking CurrentBooking = new Booking();
                    CurrentBooking.CityID = Result.getString("city");
                    CurrentBooking.CenterID = Result.getString("center");
                    CurrentBooking.CourtID = Result.getString("court");
                    CurrentBooking.Date = Result.getDate("date");
                    CurrentBooking.StartTime = Result.getTime("Start Time");
                    CurrentBooking.EndTime = Result.getTime("End Time");

                    Response.Bookings.add(CurrentBooking);
                }
            }

            return Response;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return new GetCourtBookingResponse(400);
    }
}
