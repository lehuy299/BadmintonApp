package Server;

import Database.MySqlRequest;
import Server.API.Utils;

import java.sql.Date;
import java.sql.Time;
import java.util.Map;

public class RequestHandler
{
    public static int CreateBooking(String Request) {
        Map<String, String> RequestData = Utils.SplitQuery(Request);

        if (RequestData.size() != 8)
            return 0; //Invalid parameters

        String BookingID = null, CityID = null, CenterID = null, CourtID = null, PlayerID = null;
        Date BookingDay = null;
        Time StartTime = null, EndTime = null;

        try {
            BookingID = RequestData.get("BookingID");
            CityID = RequestData.get("CityID");
            CenterID = RequestData.get("CenterID");
            CourtID = RequestData.get("CourtID");
            PlayerID = RequestData.get("PlayerID");
        }
        catch (Exception Exception) {
            Exception.printStackTrace();
            return 0; //Invalid parameters
        }

        try {
            BookingDay = Date.valueOf(RequestData.get("BookingDay"));
            StartTime = Time.valueOf(RequestData.get("StartTime"));
            EndTime = Time.valueOf(RequestData.get("EndTime"));
        }
        catch (Exception Exception) {
            Exception.printStackTrace();
            return 0; //Invalid parameters
        }

        System.out.println("BookingID: " + BookingID);
        System.out.println("BookingDay: " + BookingDay);
        System.out.println("StartTime: " + StartTime);
        System.out.println("EndTime: " + EndTime);
        System.out.println("CityID: " + CityID);
        System.out.println("CenterID: " + CenterID);
        System.out.println("CourtID: " + CourtID);
        System.out.println("PlayerID: " + PlayerID);

        MySqlRequest SqlRequest = new MySqlRequest();
        int ResultCode = SqlRequest.CreateBooking(BookingID, BookingDay, StartTime, EndTime, CityID, CenterID, CourtID, PlayerID);

        System.out.println(ResultCode);

        return ResultCode;
    }
}