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
public class GetAvalableSlotRequest {
    public Date BookingDay;
    public String CityID;
}