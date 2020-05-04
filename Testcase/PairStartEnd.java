package com.Impalord;
import java.text.*;
import java.time.*;
import java.util.*;

public class PairStartEnd {
    public LocalTime StartTime;
    public LocalTime EndTime;


    public void setStartTime(LocalTime opentime){
        this.StartTime= opentime;
    }
    public LocalTime getStart(){
        return StartTime;
    }
    public LocalTime getEnd(){
        return EndTime;
    }

    public  void setEndTime(LocalTime endtime){
        this.EndTime = endtime;
    }
    public boolean isValid(){
        if (StartTime != null ){
            return true;
        }
        else
            return false;
    }
}
