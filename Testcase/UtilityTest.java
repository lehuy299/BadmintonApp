package com.Impalord;
import org.junit.Before;
import org.junit.Test;
import java.text.*;
import java.time.*;


import java.util.*;
import static org.junit.Assert.*;

public class UtilityTest {

    PairStartEnd openningTime = new PairStartEnd();
    PairStartEnd closingTime = new PairStartEnd();

    @Before
    public void setUp(){
        LocalTime openTime = LocalTime.of(7,0);
        LocalTime closeTime = LocalTime.of(21, 0);
        openningTime.setStartTime(openTime);
        closingTime.setEndTime(closeTime);
    }

    @Test
    public void emptyBooking(){

    }
}
