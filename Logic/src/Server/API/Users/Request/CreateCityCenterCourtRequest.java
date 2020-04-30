package Server.API.Users.Request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateCityCenterCourtRequest {
    public String CityID;
    public String CenterID;
    public String CourtID;
}
