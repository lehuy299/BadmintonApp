package com.Impalord;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.*;

public class Slots {
    public LocalTime StartTime;
    public LocalTime EndTime;
    public Slots( LocalTime initime, LocalTime endtime ){
        StartTime = initime;
        EndTime = endtime;
    }

    /*public ArrayList<PairStartEnd> getAvailableSlot(ArrayList<PairStartEnd> bookings, PairStartEnd startTime){
        ArrayList<PairStartEnd> slots = new ArrayList<PairStartEnd>();
        if(startTime.isValid()){
           LocalTime newStartTime = new StartTime.getStart();
        }
            return slots;
    }*/
    public ArrayList<Slots> getAllFreeSlots(PairStartEnd bookTime, ArrayList<PairStartEnd> BookingList) { //get all free slots in one court
        LocalTime OpeningTime = LocalTime.of(7, 0); //Center opening time
        LocalTime ClosingTime = LocalTime.of(21,0); //Center closing time
        int MinimumTime = 45; //Minimum time for one booking slot
        int MaximumTime = 90; //Maximum time for one booking slot

        ArrayList<Slots> SlotList = new ArrayList<Slots>();
        if (BookingList.size() > 0) {
            for (int i = 0; i < BookingList.size(); i++) {
                    if (i == 0 && getTimeDiffByMinute(OpeningTime, BookingList.get(i).StartTime) >= MinimumTime ) {
                        SlotList.add(new Slots(OpeningTime, BookingList.get(i).StartTime));
                    }
                    if (i == BookingList.size() - 1 && getTimeDiffByMinute(BookingList.get(i).EndTime, ClosingTime) >= MinimumTime) {
                        SlotList.add(new Slots(BookingList.get(i).StartTime, ClosingTime));
                    }
                    if (i < BookingList.size() - 1 && getTimeDiffByMinute(BookingList.get(i).EndTime, BookingList.get(i+1).StartTime) >= MinimumTime && getTimeDiffByMinute(BookingList.get(i).EndTime, BookingList.get(i+1).StartTime) >= MaximumTime) {
                        SlotList.add(new Slots(BookingList.get(i).EndTime, BookingList.get(i+1).StartTime));
                    }
                }
            }
        else {
            SlotList.add(new Slots(OpeningTime, ClosingTime));
        }

        return SlotList;
    }

    public long getTimeDiffByMinute(LocalTime DateOne, LocalTime DateTwo) { //Convert difference between two time to minutes
        return (DateTwo.getMinute() - DateOne.getMinute()) / (60 * 1000);
    }

}
