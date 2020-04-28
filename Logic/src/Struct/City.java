package Struct;

import java.util.ArrayList;

public class City {
    private String CityID;
    private ArrayList<Center> Centers;

    public void setCityID(String CityID) { this.CityID = CityID; }
    public String getCityID() { return this.CityID; }
    public void setCenters(ArrayList<Center> Centers) { this.Centers = Centers; }
    public ArrayList<Center> getCenters() { return Centers; }
}
