package Database.Request;

import Database.MySqlConnection;
import Server.API.Users.Response.GetAllCityResponse;
import Struct.City;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

public class GetAllCitySql {
    public static GetAllCityResponse Get()
    {
        try {
            CallableStatement Statement = MySqlConnection.GetProcedureStatement("{Call getAllCities(?)}");
            Statement.registerOutParameter(1, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(1);

            GetAllCityResponse GetAllCityResponse = new GetAllCityResponse(ResultCode);

            ResultSet Result = Statement.getResultSet();
            if (Result.getRow() > 0)
            {
                while (Result.next()) {
                    City CurrentCity = new City();
                    CurrentCity.CityID = Result.getString("city_id");
                    GetAllCityResponse.Cities.add(CurrentCity);
                }
            }

            return GetAllCityResponse;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return new GetAllCityResponse(802);
    }
}
