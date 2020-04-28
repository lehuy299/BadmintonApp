package Server.API.Users.Handler;

import Database.MySqlRequest;
import Server.API.Constants;
import Server.API.Handler;
import Server.API.ResponseEntity;
import Server.API.StatusCode;
import Server.API.Users.Request.GetAvalableSlotRequest;
import Server.API.Users.Response.GetAvalableSlotResponse;
import Server.Errors.GlobalExceptionHandler;
import Struct.Booking;
import Struct.Center;
import Struct.Court;
import Struct.FreeSlot;
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
        ArrayList<Center> CenterList = MySqlRequest.GetAllCenterInCity(GetAvalableSlotRequest.CityID);

        if (CenterList.size() > 0) {
            for (int i = 0; i < CenterList.size(); i++) {
                ArrayList<Court> CourtList = MySqlRequest.GetAllCourtInCenter(GetAvalableSlotRequest.CityID, CenterList.get(i).getCenterID());
                for (int j = 0; j < CourtList.size(); j++) {
                    ArrayList<FreeSlot> SlotList = GetAllFreeSlots(GetAvalableSlotRequest.BookingDay, CenterList.get(i), CourtList.get(j).getBookings());
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

    public ArrayList<FreeSlot> GetAllFreeSlots(Date bookDay, Center Center, ArrayList<Booking> BookingList) { //get all free slots in one court
        Time OpeningTime = Time.valueOf("07:00:00"); //Center opening time
        Time ClosingTime = Time.valueOf("21:00:00"); //Center closing time

        ArrayList<FreeSlot> SlotList = new ArrayList<FreeSlot>();
        if (BookingList.size() > 0) {
            for (int i = 0; i < BookingList.size(); i++) {
                if (BookingList.get(i).Date.compareTo(bookDay) == 0) { //only check booking at selected date
                    if (i == 0 && getTimeDiffByMinute(OpeningTime, BookingList.get(i).StartTime) >= Center.getMinimumLength()) {
                        SlotList.add(new FreeSlot(OpeningTime, BookingList.get(i).StartTime));
                    }
                    if (i == BookingList.size() - 1 && getTimeDiffByMinute(BookingList.get(i).EndTime, ClosingTime) >= Center.getMinimumLength()) {
                        SlotList.add(new FreeSlot(BookingList.get(i).StartTime, ClosingTime));
                    }
                    if (i < BookingList.size() - 1 && getTimeDiffByMinute(BookingList.get(i).EndTime, BookingList.get(i + 1).StartTime) >= Center.getMinimumLength()) {
                        SlotList.add(new FreeSlot(BookingList.get(i).EndTime, BookingList.get(i + 1).StartTime));
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
