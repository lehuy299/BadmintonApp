package Struct;

import java.sql.Time;

public class FreeSlot {
    public FreeSlot(Time StartTime, Time EndTime) {
        this.StartTime = StartTime;
        this.EndTime = EndTime;
    }
    public FreeSlot(String CityID, String CenterID, String CourtID, Time StartTime, Time EndTime) {
        this.CityID = CityID;
        this.CenterID = CenterID;
        this.CourtID = CourtID;
        this.StartTime = StartTime;
        this.EndTime = EndTime;
    }
    public String CityID;
    public String CenterID;
    public String CourtID;
    public Time StartTime;
    public Time EndTime;
}
