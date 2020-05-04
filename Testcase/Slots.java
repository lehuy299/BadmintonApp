package com.Impalord;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.*;

public class Slots {
    public LocalTime StartTime;
    public LocalTime EndTime;

    public Slots() {};

    public Slots( LocalTime initime, LocalTime endtime ){
        StartTime = initime;
        EndTime = endtime;
    }

    /*public void setStartTime(LocalTime opening){
        this.StartTime= opening;
    }
    public LocalTime getStart(){
        return StartTime;
    }
    public LocalTime getEnd(){
        return EndTime;
    }*/

    /*public  void setEndTime(LocalTime ending){
        this.EndTime = ending;
    }*/

    /*public boolean isValid(){
        if (StartTime != null ){
            return true;
        }
        else
            return false;
    }*/

    /*public boolean IsBefore(int Hours){
        if(Hours < StartTime.getHour()){
            return true;
        }
        else
            return false;
    }*/

    public ArrayList<PairStartEnd> getAvailableSlot(ArrayList<PairStartEnd> bookings, PairStartEnd startTime){
        ArrayList<PairStartEnd> slots = new ArrayList<PairStartEnd>();
        if(startTime.isValid()){
           LocalTime newStartTime = startTime.getStart();
           for (int i = 0; i < bookings.size(); i++){
               PairStartEnd booking = bookings.get(i);
               if(newStartTime.isBefore(booking.getStart())){
                   PairStartEnd newslot = new PairStartEnd();
                   newslot.setStartTime(newStartTime);
                   newslot.setEndTime(booking.getStart());
                   slots.add(newslot);
               }
               newStartTime = booking.getEnd();
               if(newStartTime.isBefore(startTime.getEnd())){
                    PairStartEnd newSlots = new PairStartEnd();
                    newSlots.setStartTime(newStartTime);
                    newSlots.setEndTime(startTime.getEnd());
                    slots.add(newSlots);
               }
            }
        }
            return slots;
    }
    /*public ArrayList<Slots> getAllFreeSlots(LocalTime bookTime, ArrayList<Slots> BookingList) { //get all free slots in one court
        LocalTime OpeningTime = LocalTime.of(7, 0); //Center opening time
        LocalTime ClosingTime = LocalTime.of(21,0); //Center closing time
        int MinimumTime = 45; //Minimum time for one booking slot
        int MaximumTime = 90; //Maximum time for one booking slot

        ArrayList<Slots> SlotList = new ArrayList<Slots>();
        if (BookingList.size() > 0) {
            for (int i = 0; i < BookingList.size(); i++) {
                    if (i == 0 && getTimeDiffByMinute(OpeningTime.getMinute(), BookingList.get(i).StartTime.getMinute()) >= MinimumTime ) {
                        SlotList.add(new Slots(OpeningTime, BookingList.get(i).StartTime));
                    }
                    if (i == BookingList.size() - 1 && getTimeDiffByMinute(BookingList.get(i).EndTime.getMinute(), ClosingTime.getMinute()) >= MinimumTime) {
                        SlotList.add(new Slots(BookingList.get(i).StartTime, ClosingTime));
                    }
                    if (i < BookingList.size() - 1 && getTimeDiffByMinute(BookingList.get(i).EndTime.getMinute(), BookingList.get(i+1).StartTime.getMinute()) >= MinimumTime && getTimeDiffByMinute(BookingList.get(i).EndTime.getMinute(), BookingList.get(i+1).StartTime.getMinute()) >= MaximumTime) {
                        SlotList.add(new Slots(BookingList.get(i).EndTime, BookingList.get(i+1).StartTime));
                    }
                }
            }
        else {
            SlotList.add(new Slots(OpeningTime, ClosingTime));
        }

        return SlotList;
    }*/

    public long getTimeDiffByMinute(int DateOne, int DateTwo) { //Convert difference between two time to minutes
        return (DateTwo - DateOne);
    }

}
