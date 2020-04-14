package com.Impalord;

import java.util.ArrayList;

public class Method {
    public String slot ;
    public int time;
    public String Court;

    public void  createSlot( String slot, int timebook){
        slot = this.slot;
        timebook = this.time;
    }

    public String  getSlot( ) {
        return slot;
    }

    public  int getTime(){
        return time;
    }


    public String delSlot(){
        slot = null;
        return null;
    }
    public void  createCourt( String Court){
        Court = this.Court;
    }

    public String getCourt() {
        return Court;
    }

    public String delCourt(){
        Court = null;
        return Court;
    }
}
