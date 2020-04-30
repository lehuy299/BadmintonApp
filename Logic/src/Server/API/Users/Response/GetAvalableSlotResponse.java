package Server.API.Users.Response;

import Struct.FreeSlot;

import java.util.ArrayList;

public class GetAvalableSlotResponse {
    public GetAvalableSlotResponse(int ResultCode) { this.ResultCode = ResultCode; this.FreeSlots = new ArrayList<>(); }
    public int ResultCode;
    public ArrayList<FreeSlot> FreeSlots;
}
