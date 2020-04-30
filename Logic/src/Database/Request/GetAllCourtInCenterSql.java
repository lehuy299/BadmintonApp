package Database.Request;

import Database.MySqlConnection;
import Server.API.Users.Request.GetAllCourtInCenterRequest;
import Server.API.Users.Response.GetAllCourtInCenterResponse;
import Struct.Court;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

public class GetAllCourtInCenterSql {
    public static GetAllCourtInCenterResponse Get(GetAllCourtInCenterRequest Request)
    {
        try {
            CallableStatement Statement = MySqlConnection.GetProcedureStatement("{Call getAllCitiesCentersCourts(?,?,?)}");
            Statement.setString(1, Request.CityID);
            Statement.setString(2, Request.CenterID);
            Statement.registerOutParameter(3, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(3);

            GetAllCourtInCenterResponse GetAllCourtInCenterResponse = new GetAllCourtInCenterResponse(ResultCode);

            ResultSet Result = Statement.getResultSet();
            if (Result.getRow() > 0)
            {
                while (Result.next()) {
                    Court CurrentCourt = new Court();
                    CurrentCourt.CourtID =  Result.getString("court_id");
                    GetAllCourtInCenterResponse.Courts.add(CurrentCourt);
                }
            }

            return GetAllCourtInCenterResponse;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return new GetAllCourtInCenterResponse(1005);
    }
}
