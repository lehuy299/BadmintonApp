package com.Impalord;
import java.util.*;
import java.text.*;

public  class Slot {
    public Slot(Date StartTime, Date EndTime) {
        this.StartTime = StartTime;
        this.EndTime = EndTime;
    }
    public static DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    public static DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");

    public Date StartTime;
    public Date EndTime;

    public String getAvailableSlots(String SelectedDate, String SelectedCityID) {
        Date Today = dateFormat.format(new Date);

        Date bookDay;
        try {
            bookDay = dateFormat.parse(SelectedDate);
        }
        catch{	//if input String is invalid date, return an error
            return "getAvailableSlotsunvalidday";
        }

        if(bookDay.compareTo(Today) > 0) { //if choosen date occurs before current date, return an error
            return "getAvailableSlotsdayinthepast";
        }
        else {
            // Result Structure :
            // SUCCESSCODE|arrayof(centerID, arrayof(courtID, arrayof(startHour + endHour)))
            // => Success+CenterID_1+CenterID_2;CourtID_1;CourtID_2;CourtID_3,10:30-12:00,14:00-15:30
            // => Explaination: Successful request, return two centers (Center 1 and Center 2, Center 1 doesn't have any court, Center 2 has three courts
            // => Explaination: Court 1 and Court 2 in Center 2 doesn't have any free slots, Court 3 in Center 2 has two free slots from 10:30 AM to 12:00 PM and 14:00 PM to 15-30 PM

            StringBuilder Result = new StringBuilder("Success");

            ArrayList<Center> CenterList = getAllCenterByCityID(SelectedCityID); //Get all centers in selected city
            if (CenterList.size() > 0) {
                for (int i = 0; i < CenterList.size(); i++) {
                    Result.append("+" + CenterList[i].CenterID); //Connect center and center with plus symbol (+)

                    ArrayList<Court> CourtList = getAllCourtByCenterID(CenterList[i].CenterID); //Get all courts in current center
                    for (int j = 0; j < CourtList.size(); j++) {
                        Result.append(";" + CourtList[j].CourtID); //Connect court and court with semicolon symbol (;)

                        ArrayList<Slot> SlotList = getAllFreeSlots(bookDay, CourtList[j].getBookings()); //Calculate free slots with existing bookings in Courts
                        for (int k = 0; k < SlotList.size(); k++) {
                            Result.append("," + SlotList[k].StartTime + "-" + SlotList[k].EndTime); //Connect freeslot and freeslot with comma (,) and connect startTime and EndTime of each freeslot with hyphen (-)
                        }
                    }
                }
                return Result;
            }
            else { //if city has no center, return an error
                return "getAvailableSlotsunvalidcityId";
            }
        }
    }

    public ArrayList<Slot> getAllFreeSlots(Date bookDay, ArrayList<Court> BookingList) { //get all free slots in one court
        Date OpeningTime = timeFormat.parse("07:00:00"); //Center opening time
        Date ClosingTime = timeFormat.parse("21:00:00"); //Center closing time
        int MinimumTime = 45; //Minimum time for one booking slot
        int MaximumTime = 90; //Maximum time for one booking slot

        ArrayList<Slot> SlotList = new ArrayList<Slot>();
        if (BookingList.size() > 0) {
            for (int i = 0; i < BookingList.size(); i++) {
                if (BookingList[i].StartTime.getDayOfYear() == bookDay.getDayOfYear()) { //only check booking at selected date
                    if (i == 0 && getTimeDiffByMinute(OpeningTime, BookingList[i].StartTime) >= MinimumTime ) {
                        SlotList.add(new Slot(OpeningTime, BookingList[i].StartTime);
                    }
                    if (i == BookingList.size() - 1 && getTimeDiffByMinute(BookingList[i].EndTime, ClosingTime) >= MinimumTime) {
                        SlotList.add(new Slot(BookingList[i].StartTime, ClosingTime);
                    }
                    if (i < BookingList.size() - 1 && getTimeDiffByMinute(BookingList[i].EndTime, BookingList[i+1].StartTime) >= MinumumTime && getTimeDiffByMinute(BookingList[i].EndTime, BookingList[i+1].StartTime) >= MaximumTime) {
                        SlotList.add(new Slot(BookingList[i].EndTime, BookingList[i+1].StartTime);
                    }
                }
            }
        }
        else {
            SlotList.add(new Slot(OpeningTime, ClosingTime));
        }

        return SlotList;
    }

    public long getTimeDiffByMinute(Date DateOne, Date DateTwo) { //Convert difference between two time to minutes
        return (DateTwo.getTime() - DateOne.getTime()) / (60 * 1000);
    }
