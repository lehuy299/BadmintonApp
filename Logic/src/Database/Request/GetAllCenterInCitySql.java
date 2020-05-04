package Database.Request;

import Database.MySqlConnection;
import Server.API.Users.Request.GetAllCenterInCityRequest;
import Server.API.Users.Response.GetAllCenterInCityResponse;
import Struct.Center;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

public class GetAllCenterInCitySql {
    public static GetAllCenterInCityResponse Get(GetAllCenterInCityRequest Request)
    {
        try {
            CallableStatement Statement = MySqlConnection.GetProcedureStatement("{Call getAllCitiesCenters(?,?)}");
            Statement.setString(1, Request.CityID);
            Statement.registerOutParameter(2, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(2);

            GetAllCenterInCityResponse GetAllCenterInCityResponse = new GetAllCenterInCityResponse(ResultCode);

            ResultSet Result = Statement.getResultSet();

            System.out.println(Result.getRow());
            if (Result.getRow() > 0)
            {
                while (Result.next()) {
                    Center CurrentCenter = new Center();
                    CurrentCenter.CenterID = Result.getString("center_id");
                    CurrentCenter.MinimumLength = Result.getInt("minimun_length");
                    GetAllCenterInCityResponse.Centers.add(CurrentCenter);
                }
            }

            return GetAllCenterInCityResponse;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return new GetAllCenterInCityResponse(904);
    }
}
