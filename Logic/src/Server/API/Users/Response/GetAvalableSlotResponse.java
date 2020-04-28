package Server.API.Users.Response;

import Struct.FreeSlot;

import java.util.List;

public class GetAvalableSlotResponse {
    public GetAvalableSlotResponse(int ResultCode) { this.ResultCode = ResultCode; }
    public int ResultCode;
    public List<FreeSlot> FreeSlots;
}
