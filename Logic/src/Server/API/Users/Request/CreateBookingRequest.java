package Server.API.Users.Request;

import lombok.*;

import java.sql.Time;
import java.sql.Date;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateBookingRequest {
    public Date BookingDay;
    public Time StartTime;
    public Time EndTime;
    public String CityID;
    public String CenterID;
    public String CourtID;
    public String PlayerID;
}
