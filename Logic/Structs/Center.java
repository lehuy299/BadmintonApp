package Structs;

import java.util.ArrayList;

public class Center {
    private String CenterID;
    private ArrayList<Court> Courts;

    public void setCenterID(String CenterID) { this.CenterID = CenterID; }
    public String getCenterID() { return this.CenterID; }
    public void setCourts(ArrayList<Court> Courts) { this.Courts = Courts; }
    public ArrayList<Court> getCourts() { return Courts; }
}
