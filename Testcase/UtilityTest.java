package com.Impalord;
import org.junit.Before;
import org.junit.Test;

import java.awt.image.AreaAveragingScaleFilter;
import java.text.*;
import java.time.*;


import java.util.*;
import static org.junit.Assert.*;

public class UtilityTest {

    PairStartEnd openningTime = new PairStartEnd() ;


    @Before
    public void setUp(){
        LocalTime openTime = LocalTime.of(7,0);
        LocalTime closeTime = LocalTime.of(21, 0);
        openningTime.setStartTime(openTime);
        openningTime.setEndTime(closeTime);
    }

    @Test
    public void emptyBooking(){
       ArrayList<PairStartEnd> booking = new ArrayList<PairStartEnd>();
       Slots slot = new Slots();
       ArrayList<PairStartEnd> result = new ArrayList<>();
       result = slot.getAvailableSlot(booking, openningTime);
       assertTrue(result.size() == 1
                   && result.get(0).getStart().equals(openningTime.getStart())
                   && result.get(0).getEnd().equals(openningTime.getEnd()));
    }

    @Test
    public void bookingEarliest(){
        ArrayList<PairStartEnd> booking = new ArrayList<PairStartEnd>();
        Slots slot = new Slots();
        PairStartEnd earliest = new PairStartEnd();
        earliest.setStartTime(openningTime.getStart());
        LocalTime earliestBookingEnd = LocalTime.of(8,0);
        earliest.setEndTime(earliestBookingEnd);
        booking.add(earliest);
        ArrayList<PairStartEnd> result = new ArrayList<>();
        result = slot.getAvailableSlot(booking, openningTime );
        assertTrue(result.size() == 1
                && result.get(0).getStart().equals(earliestBookingEnd)
                && result.get(0).getEnd().equals(openningTime.getEnd()));
    }

    @Test
    public void bookingLastest(){
        ArrayList<PairStartEnd> booking = new ArrayList<PairStartEnd>();
        Slots slot = new Slots();
        PairStartEnd lastestBooking = new PairStartEnd();
        LocalTime LastestStart = LocalTime.of(20, 0);
        lastestBooking.setStartTime(LastestStart);
        lastestBooking.setEndTime(openningTime.getEnd());
        booking.add(lastestBooking);
        ArrayList<PairStartEnd> result = new ArrayList<>();
        result = slot.getAvailableSlot(booking, openningTime);
        assertTrue(result.size() == 1
                    && result.get(0).getStart().equals(openningTime.getStart())
                    && result.get(0).getEnd().equals(LastestStart));
    }

    @Test
    public void nearBooking(){
        ArrayList<PairStartEnd> booking = new ArrayList<PairStartEnd>();
        PairStartEnd book1 = new PairStartEnd();
        book1.setStartTime(LocalTime.of(8,0));
        book1.setEndTime(LocalTime.of(9,0));
        booking.add(book1);

        PairStartEnd book2 = new PairStartEnd();
        book2.setStartTime(LocalTime.of(9,0));
        book2.setEndTime(LocalTime.of(10,0));
        booking.add(book2);

        Slots slots = new Slots();
        ArrayList<PairStartEnd> result = slots.getAvailableSlot(booking, openningTime);
        assertTrue(result.size() == 2
                    && result.get(0).getStart().equals(openningTime.getStart())
                    && result.get(0).getEnd().equals(book1.getStart())
                    && result.get(1).getStart().equals(book2.getEnd())
                    && result.get(1).getEnd().equals(openningTime.getEnd()));
    }

    @Test
    public void nonnearBooking(){
        ArrayList<PairStartEnd> booking = new ArrayList<PairStartEnd>();
        PairStartEnd book1 = new PairStartEnd();
        book1.setStartTime(LocalTime.of(8,0));
        book1.setEndTime(LocalTime.of(9,0));
        booking.add(book1);

        PairStartEnd book2 = new PairStartEnd();
        book2.setStartTime(LocalTime.of(10,0));
        book2.setEndTime(LocalTime.of(11,0));
        booking.add(book2);

        Slots slots = new Slots();
        ArrayList<PairStartEnd> result = slots.getAvailableSlot(booking, openningTime);
        assertTrue(result.size() == 3
                && result.get(0).getStart().equals(openningTime.getStart())
                && result.get(0).getEnd().equals(book1.getStart())
                && result.get(1).getStart().equals(book1.getEnd())
                && result.get(1).getEnd().equals(book2.getStart())
                && result.get(2).getStart().equals(book2.getEnd())
                && result.get(2).getEnd().equals(openningTime.getEnd()));
    }

}
