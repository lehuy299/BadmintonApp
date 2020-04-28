package Struct;

import java.util.ArrayList;

public class Center {
    private String CenterID;
    private ArrayList<Court> Courts;
    private int MinimumLength;

    public void setCenterID(String CenterID) { this.CenterID = CenterID; }
    public String getCenterID() { return this.CenterID; }
    public void setCourts(ArrayList<Court> Courts) { this.Courts = Courts; }
    public ArrayList<Court> getCourts() { return Courts; }
    public void setMinimumLength(int MinimumLength) { this.MinimumLength = MinimumLength; }
    public int getMinimumLength() { return MinimumLength; }
}
