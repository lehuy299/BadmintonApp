package Database.Request;

import Database.MySqlConnection;
import Server.API.Users.Request.CancelBookingRequest;
import Server.API.Users.Response.CancelBookingResponse;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

public class CancelBookingSql {
    public static CancelBookingResponse Post(CancelBookingRequest Request)
    {
        try {
            CallableStatement Statement = MySqlConnection.GetProcedureStatement("{Call cancelBooking(?,?,?)}");
            Statement.setInt(1, Request.BookingID);
            Statement.setString(2, Request.PlayerID);
            Statement.registerOutParameter(3, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(3);

            CancelBookingResponse Response = new CancelBookingResponse(ResultCode);

            return Response;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return new CancelBookingResponse(606);
    }
}
