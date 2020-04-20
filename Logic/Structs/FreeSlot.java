package Structs;

import java.util.Date;

public class FreeSlot {
    public FreeSlot(Date StartTime, Date EndTime) {
        this.StartTime = StartTime;
        this.EndTime = EndTime;
    }
    public Date StartTime;
    public Date EndTime;
}
