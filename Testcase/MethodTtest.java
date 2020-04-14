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
    public void getAvailableSlotTimeCheckTwo() throws Exception {
        Method Court = new Method();
        Method Slot = new Method();
        Court.delCourt();
        Slot.delSlot();
        Court.createCourt("HaNoi");
        Slot.createSlot("SlotA1", 45);
        //System.out.println(Slot.getSlot());
        assertTrue(Court.getCourt() == "HaNoi");
        assertTrue(Slot.getSlot() == "SlotA1");
        assertTrue(Slot.getTime() >= 45 && Slot.getTime() <= 90);
    }


    @Test
    public void getAvailableSlotTimeCheckThree() throws Exception{
        Method Court2 = new Method();
        Method Slot2 = new Method();
        Court2.delCourt();
        Slot2.delSlot();
        Court2.createCourt("Hanoi");
        Slot2.createSlot("SlotA1", 90);
        //System.out.println(Slot2.getSlot());
        assertTrue(Court2.getCourt() == "Hanoi");
        assertTrue(Slot2.getSlot() == "SlotA1");
        assertTrue(Slot2.getTime() >= 45 && Slot2.getTime() <= 90);
    }
}
