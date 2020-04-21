package Database;

import Structs.Booking;

import java.sql.*;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;

public class MySqlRequest {
    private static String DB_URL = "jdbc:mysql://localhost:3306/booking_app";
    private static String USER_NAME = "root";
    private static String PASSWORD = "teamdpe2020";
    private MySqlConnection CurrentConnection = new MySqlConnection(DB_URL, USER_NAME, PASSWORD);

    public int CreateBooking(String BookingID, Date BookingDay, Time StartTime, Time EndTime, String CityID, String CenterID, String CourtID, String PlayerID)
    {
        try {
            CallableStatement Statement = CurrentConnection.GetProcedureStatement("{Call createBooking(?,?,?,?,?,?,?,?,?)}");
            Statement.setString(1, BookingID);
            Statement.setDate(2, BookingDay);
            Statement.setTime(3, StartTime);
            Statement.setTime(4, EndTime);
            Statement.setString(5, CityID);
            Statement.setString(6, CenterID);
            Statement.setString(7, CourtID);
            Statement.setString(8, PlayerID);
            Statement.registerOutParameter(9, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(9);

            return ResultCode;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public AbstractMap.SimpleEntry<Integer, List<Booking>> GetCourtBooking(Date Day, String CourtID, String CenterID, String CityID)
    {
        try {
            CallableStatement Statement = CurrentConnection.GetProcedureStatement("{Call getCourtBooking(?,?,?,?,?)}");
            Statement.setDate(1, Day);
            Statement.setString(2, CourtID);
            Statement.setString(3, CenterID);
            Statement.setString(4, CityID);
            Statement.registerOutParameter(5, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(5);

            List<Booking> Bookings = new ArrayList<Booking>();

            ResultSet Result = Statement.getResultSet();
            while (Result.next()) {
                String OutCourtID = Result.getString("court");
                Date OutDate = Result.getDate("date");
                Time OutStartTime = Result.getTime("Start Time");
                Time OutEndTime = Result.getTime("End Time");

                Booking CurrentBooking = new Booking(OutCourtID, OutDate, OutStartTime, OutEndTime);
                Bookings.add(CurrentBooking);
            }

            return new AbstractMap.SimpleEntry<>(ResultCode, Bookings);
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void GetAllCentersInCity(String City)
    {
        try {
            CallableStatement Statement = CurrentConnection.GetProcedureStatement("{Call getAllCitiesCenters(?,?)}");
            Statement.setString(1, City);
            Statement.registerOutParameter(2, Types.INTEGER);
            Statement.execute();

            int ResultCode = Statement.getInt(2);
            System.out.println(ResultCode);

            ResultSet Result = Statement.getResultSet();
            while (Result.next()) {
                for(int i=1;i<=Result.getMetaData().getColumnCount();i++){
                    System.out.println(Result.getString(i));
                }
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
