package Server;

import Database.MySqlRequest;
import Server.API.Utils;
import Structs.Booking;

import java.sql.Date;
import java.sql.Time;
import java.util.AbstractMap;
import java.util.List;
import java.util.Map;

public class RequestHandler
{
    public static String CreateBooking(String Request) {
        Map<String, String> RequestData = Utils.SplitQuery(Request);

        if (RequestData.size() != 7)
            return "619"; //Invalid parameters

        String BookingID, CityID = null, CenterID = null, CourtID = null, PlayerID = null;
        Date BookingDay = null;
        Time StartTime = null, EndTime = null;

        try {
            BookingID = Utils.RandomString(6);
            CityID = RequestData.get("CityID");
            CenterID = RequestData.get("CenterID");
            CourtID = RequestData.get("CourtID");
            PlayerID = RequestData.get("PlayerID");
            BookingDay = Date.valueOf(RequestData.get("BookingDay"));
            StartTime = Time.valueOf(RequestData.get("StartTime"));
            EndTime = Time.valueOf(RequestData.get("EndTime"));
        }
        catch (Exception Exception) {
            Exception.printStackTrace();
            return "619"; //Invalid parameters
        }

        //
        //Check all variables with external function, regex,.. later
        //

        System.out.println("BookingID: " + BookingID);
        System.out.println("BookingDay: " + BookingDay);
        System.out.println("StartTime: " + StartTime);
        System.out.println("EndTime: " + EndTime);
        System.out.println("CityID: " + CityID);
        System.out.println("CenterID: " + CenterID);
        System.out.println("CourtID: " + CourtID);
        System.out.println("PlayerID: " + PlayerID);

        MySqlRequest SqlRequest = new MySqlRequest();
        StringBuilder ResultString = new StringBuilder();
        ResultString.append(SqlRequest.CreateBooking(BookingID, BookingDay, StartTime, EndTime, CityID, CenterID, CourtID, PlayerID));

        System.out.println(ResultString);

        return ResultString.toString();
    }

    public static String GetCourtBooking(String Request) {
        Map<String, String> RequestData = Utils.SplitQuery(Request);

        if (RequestData.size() != 4)
            return "0"; //Invalid parameters

        String CourtID = null, CenterID = null, CityID = null;
        Date ChooseDay = null;

        try {
            CityID = RequestData.get("CityID");
            CenterID = RequestData.get("CenterID");
            CourtID = RequestData.get("CourtID");
            ChooseDay = Date.valueOf(RequestData.get("ChooseDay"));
        }
        catch (Exception Exception) {
            Exception.printStackTrace();
            return "0"; //Invalid parameters
        }

        //
        //Check all variables with external function, regex,.. later
        //

        System.out.println("CourtID: " + CourtID);
        System.out.println("CenterID: " + CenterID);
        System.out.println("CityID: " + CityID);
        System.out.println("ChooseDay: " + ChooseDay);


        MySqlRequest SqlRequest = new MySqlRequest();
        AbstractMap.SimpleEntry<Integer, List<Booking>> RequestResult = SqlRequest.GetCourtBooking(ChooseDay, CourtID, CenterID, CityID);

        StringBuilder ResultString = new StringBuilder();
        ResultString.append(String.valueOf(RequestResult.getKey()));
        for (Booking Booking : RequestResult.getValue()) {
            ResultString.append("|" + Booking.ToRequestString() );
        }

        System.out.println(ResultString);

        return ResultString.toString();
    }
}