package Database.Request;

import Database.MySqlConnection;
import Server.API.Users.Request.CreateCityCenterRequest;
import Server.API.Users.Response.CreateCityCenterResponse;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

public class CreateCityCenterSql {
    public static CreateCityCenterResponse Create(CreateCityCenterRequest Request)
    {
        try {
            CallableStatement Statement = MySqlConnection.GetProcedureStatement("{Call createCityCenter(?,?,?)}");
            Statement.setString(1, Request.CityID);
            Statement.setString(2, Request.CenterID);
            Statement.registerOutParameter(3, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(3);

            CreateCityCenterResponse Response = new CreateCityCenterResponse(ResultCode);

            return Response;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return new CreateCityCenterResponse(205);
    }
}
