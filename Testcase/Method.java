package com.Impalord;

import java.util.ArrayList;

public class Method {
    public String slot ;
    public int time;
    public  String starttime;
    public int Court;

    public void  createSlot( String slot, int timebook, String timestart){
        slot = this.slot;
        timebook = this.time;
        timestart = this.starttime;
    }

    public ArrayList<String> getSlot() {
        ArrayList SLOT = new ArrayList<String>();
        SLOT.add(slot);
        SLOT.add(time);
        SLOT.add(starttime);
        return SLOT;
    }


    public String delSlot(){
        slot = null;
        return null;
    }
    public void  createCourt( int Court){
        Court = this.Court;
    }

    public int getCourt() {
        return Court;
    }

    public int delCourt(){
        Court = 0;
        return Court;
    }
}
