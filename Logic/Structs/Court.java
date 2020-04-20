package Structs;

import java.util.ArrayList;

public class Court {
    private String CourtID;
    private ArrayList<Booking> Bookings;

    public void setCourtID(String CourtID) { this.CourtID = CourtID; }
    public String getCourtID() { return this.CourtID; }
    public void setBookings(ArrayList<Booking> Bookings) { this.Bookings = Bookings; }
    public ArrayList<Booking> getBookings() { return Bookings; }
}
