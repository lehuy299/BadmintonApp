package Database.Request;

import Database.MySqlConnection;
import Server.API.Users.Request.CreateCityCenterCourtRequest;
import Server.API.Users.Response.CreateCityCenterCourtResponse;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

public class CreateCityCenterCourtSql {
    public static CreateCityCenterCourtResponse Create(CreateCityCenterCourtRequest Request)
    {
        try {
            CallableStatement Statement = MySqlConnection.GetProcedureStatement("{Call createCityCenterCourt(?,?,?)}");
            Statement.setString(1, Request.CourtID);
            Statement.setString(2, Request.CityID);
            Statement.setString(3, Request.CenterID);
            Statement.registerOutParameter(4, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(4);

            CreateCityCenterCourtResponse Response = new CreateCityCenterCourtResponse(ResultCode);

            return Response;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return new CreateCityCenterCourtResponse(307);
    }
}
