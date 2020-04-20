package Structs;

import java.util.Date;

public class Booking {
    public Booking(Date StartTime, Date EndTime) {
        this.StartTime = StartTime;
        this.EndTime = EndTime;
    }
    Date StartTime;
    Date EndTime;
}
