package Database.Request;

import Database.MySqlConnection;
import Server.API.Users.Request.CreateBookingRequest;
import Server.API.Users.Response.CreateBookingResponse;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

public class CreateBookingSql {
    public static CreateBookingResponse Create(CreateBookingRequest Request)
    {
        try {
            CallableStatement Statement = MySqlConnection.GetProcedureStatement("{Call createBooking(?,?,?,?,?,?,?,?)}");
            Statement.setDate(1, Request.BookingDay);
            Statement.setTime(2, Request.StartTime);
            Statement.setTime(3, Request.EndTime);
            Statement.setString(4, Request.CityID);
            Statement.setString(5, Request.CenterID);
            Statement.setString(6, Request.CourtID);
            Statement.setString(7, Request.PlayerID);
            Statement.registerOutParameter(8, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(8);

            CreateBookingResponse Response = new CreateBookingResponse(ResultCode);

            return Response;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return new CreateBookingResponse(517);
    }
}
