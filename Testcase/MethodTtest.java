package com.Impalord;
import org.junit.Test;

import java.awt.image.AreaAveragingScaleFilter;
import java.util.*;
import static org.junit.Assert.*;

public class MethodTtest {


    @Test
    public void getSlotEmpty() throws Exception{
        ArrayList result = new ArrayList();
        assertTrue(result.isEmpty());
    }

    @Test
    public void getAvailableSlotTimeCheckOne() throws Exception{
        Method Court = new Method();
        Method Slot = new Method();
        Court.delCourt();
        Slot.delSlot();
        Court.createCourt(1);
        Slot.createSlot("SlotA1", 45, "07:00:00");
        ArrayList<Integer> result = new ArrayList<Integer>();
        result.add(0,Court.getCourt());
        //result.add(1,Slot.getSlot());
        System.out.println(result);
        //assertTrue(result.get(0) == "Stadium1");
        //assertTrue(result.get(1) == Slot.getSlot().get(0));
    }

    @Test
    public void getAvailableSlotTimeCheckTwo() throws Exception{
        Method Court = new Method();
        Method Slot = new Method();
        Court.delCourt();
        Slot.delSlot();
        Court.createCourt(2);
        Slot.createSlot("SlotA1", 45, "21:00:00");
        System.out.println(Slot.getSlot());
        //assertTrue(Court.getCourt() = 1);
        //assertTrue(Slot.getSlot().get(0) == "SlotA1");
        // assertTrue(Slot.getSlot().get(1) >= 45 && Slot.getSlot().get(1) <= 90);
        // assertTrue(Slot.getSlot().get(0) == "21:00:00");
    }

    public void getAvailableSlotTimeCheckThree() throws Exception{
        Method Court = new Method();
        Method Slot = new Method();
        Court.delCourt();
        Slot.delSlot();
        Court.createCourt(2);
        Slot.createSlot("SlotA1", 90, "12:00:00");
        System.out.println(Slot.getSlot());
        //assertTrue(Court.getCourt() = 1);
        //assertTrue(Slot.getSlot().get(0) == "SlotA1");
        // assertTrue(Slot.getSlot().get(1) >= 45 &&
        // Slot.getSlot().get(1) <= 90);
        // assertTrue(Slot.getSlot().get(0) == "21:00:00");
    }
}
