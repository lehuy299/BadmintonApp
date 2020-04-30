package Server.API.Users.Handler;

import Database.Request.GetAllCenterInCitySql;
import Database.Request.GetAllCourtInCenterSql;
import Database.Request.GetCourtBookingSql;
import Server.API.Constants;
import Server.API.Handler;
import Server.API.ResponseEntity;
import Server.API.StatusCode;
import Server.API.Users.Request.GetAvalableSlotRequest;
import Server.API.Users.Request.GetCourtBookingRequest;
import Server.API.Users.Response.GetAvalableSlotResponse;
import Server.Errors.GlobalExceptionHandler;
import Struct.*;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.InputStream;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;

public class GetAvalableSlotHandler extends Handler {
    public GetAvalableSlotHandler(String MethodAllowed, ObjectMapper ObjectMapper, GlobalExceptionHandler GlobalExceptionHandler)  {
        super(MethodAllowed, ObjectMapper, GlobalExceptionHandler);
    }

    @Override
    protected ResponseEntity<GetAvalableSlotResponse> DoPost(InputStream InputStream) {
        GetAvalableSlotRequest GetAvalableSlotRequest = ReadRequest(InputStream, GetAvalableSlotRequest.class);

        ArrayList<FreeSlot> AllFreeSlots = new ArrayList<>();
        ArrayList<Center> CenterList = GetAllCenterInCitySql.Get(GetAvalableSlotRequest.CityID).Centers;

        if (CenterList.size() > 0) {
            for (int i = 0; i < CenterList.size(); i++) {
                Center CurrentCenter = CenterList.get(i);

                ArrayList<Court> CourtList = GetAllCourtInCenterSql.Get(GetAvalableSlotRequest.CityID, CurrentCenter.CenterID).Courts;
                for (int j = 0; j < CourtList.size(); j++) {
                    Court CurrentCourt = CourtList.get(j);

                    GetCourtBookingRequest GetCourtBookingRequest = new GetCourtBookingRequest();
                    GetCourtBookingRequest.BookingDay = GetAvalableSlotRequest.BookingDay;
                    GetCourtBookingRequest.CityID = GetAvalableSlotRequest.CityID;
                    GetCourtBookingRequest.CenterID = CurrentCenter.CenterID;
                    GetCourtBookingRequest.CourtID = CurrentCourt.CourtID;

                    ArrayList<Booking> CourtBookings = GetCourtBookingSql.Get(GetCourtBookingRequest).Bookings;
                    ArrayList<FreeSlot> SlotList = GetAllFreeSlots(GetAvalableSlotRequest.BookingDay, GetAvalableSlotRequest.CityID, CurrentCenter.CenterID, CurrentCourt.CourtID, CurrentCenter.MinimumLength, CourtBookings);
                    for (int k = 0; k < SlotList.size(); k++) {
                        AllFreeSlots.add(SlotList.get(i));
                    }
                }
            }
        }
        GetAvalableSlotResponse GetAvalableSlotResponse = new GetAvalableSlotResponse(0);
        GetAvalableSlotResponse.FreeSlots = AllFreeSlots;

        return new ResponseEntity<>(StatusCode.OK, GetHeaders(Constants.ContentType, Constants.ApplicationJSON), GetAvalableSlotResponse);
    }

    public ArrayList<FreeSlot> GetAllFreeSlots(Date bookDay, String CityID, String CenterID, String CourtID, int MinimumLength, ArrayList<Booking> BookingList) { //get all free slots in one court
        Time OpeningTime = Time.valueOf("07:00:00"); //Center opening time
        Time ClosingTime = Time.valueOf("21:00:00"); //Center closing time

        ArrayList<FreeSlot> SlotList = new ArrayList<FreeSlot>();
        if (BookingList.size() > 0) {
            for (int i = 0; i < BookingList.size(); i++) {
                if (BookingList.get(i).Date.compareTo(bookDay) == 0) { //only check booking at selected date
                    if (i == 0 && getTimeDiffByMinute(OpeningTime, BookingList.get(i).StartTime) >= MinimumLength) {
                        SlotList.add(new FreeSlot(CityID, CenterID, CourtID, OpeningTime, BookingList.get(i).StartTime));
                    }
                    if (i == BookingList.size() - 1 && getTimeDiffByMinute(BookingList.get(i).EndTime, ClosingTime) >= MinimumLength) {
                        SlotList.add(new FreeSlot(CityID, CenterID, CourtID, BookingList.get(i).StartTime, ClosingTime));
                    }
                    if (i < BookingList.size() - 1 && getTimeDiffByMinute(BookingList.get(i).EndTime, BookingList.get(i + 1).StartTime) >= MinimumLength) {
                        SlotList.add(new FreeSlot(CityID, CenterID, CourtID, BookingList.get(i).EndTime, BookingList.get(i + 1).StartTime));
                    }
                }
            }
        }
        else {
            SlotList.add(new FreeSlot(OpeningTime, ClosingTime));
        }

        return SlotList;
    }

    public long getTimeDiffByMinute(Time DateOne, Time DateTwo) { //Convert difference between two time to minutes
        return (DateTwo.getTime() - DateOne.getTime()) / (60 * 1000);
    }
}
