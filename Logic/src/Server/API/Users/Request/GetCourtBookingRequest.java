package Server.API.Users.Request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GetCourtBookingRequest {
    public Date BookingDay;
    public String CityID;
    public String CenterID;
    public String CourtID;
}
