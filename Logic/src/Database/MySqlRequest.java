package Database;

import Server.API.Users.Request.CreateBookingRequest;
import Server.API.Users.Request.GetCourtBookingRequest;
import Server.API.Users.Response.CreateBookingResponse;
import Server.API.Users.Response.GetCourtBookingResponse;
import Struct.Booking;
import Struct.Center;
import Struct.Court;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class MySqlRequest {
    public static CreateBookingResponse CreateBooking(CreateBookingRequest Request)
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
        return new CreateBookingResponse(400);
    }

    public static GetCourtBookingResponse GetCourtBooking(GetCourtBookingRequest Request)
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

            List<Booking> Bookings = new ArrayList<Booking>();

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

                    Bookings.add(CurrentBooking);
                }
            }

            GetCourtBookingResponse Response = new GetCourtBookingResponse(ResultCode);
            Response.Bookings = Bookings;

            return Response;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return new GetCourtBookingResponse(400);
    }

    public static ArrayList<Center> GetAllCenterInCity(String CityID)
    {
        try {
            CallableStatement Statement = MySqlConnection.GetProcedureStatement("{Call getAllCitiesCenters(?,?)}");
            Statement.setString(1, CityID);
            Statement.registerOutParameter(2, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(2);


            ArrayList<Center> Centers = new ArrayList<>();

            ResultSet Result = Statement.getResultSet();
            if (Result.getRow() > 0)
            {
                while (Result.next()) {
                    Center CurrentCenter = new Center();
                    CurrentCenter.setCenterID( Result.getString("center_id"));
                    CurrentCenter.setMinimumLength(Result.getInt("minimun_length"));
                    Centers.add(CurrentCenter);
                }
            }

            return Centers;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static ArrayList<Court> GetAllCourtInCenter(String CityID, String CenterID)
    {
        try {
            CallableStatement Statement = MySqlConnection.GetProcedureStatement("{Call getAllCitiesCentersCourts(?,?,?)}");
            Statement.setString(1, CityID);
            Statement.setString(2, CenterID);
            Statement.registerOutParameter(3, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(3);

            ArrayList<Court> Courts = null;

            ResultSet Result = Statement.getResultSet();
            if (Result.getRow() > 0)
            {
                Courts = new ArrayList<Court>();
                while (Result.next()) {
                    Court CurrentCourt = new Court();
                    CurrentCourt.setCourtID( Result.getString("court_id"));
                    Courts.add(CurrentCourt);
                }
            }

            return Courts;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
