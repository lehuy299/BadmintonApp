package Database.Request;

import Database.MySqlConnection;
import Server.API.Users.Request.GetPlayerInfoRequest;
import Server.API.Users.Response.GetPlayerInfoResponse;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

public class GetPlayerInfoSql {
    public static GetPlayerInfoResponse Get(GetPlayerInfoRequest Request)
    {
        try {
            CallableStatement Statement = MySqlConnection.GetProcedureStatement("{Call getPlayersInfo(?,?)}");
            Statement.setString(1, Request.PlayerID);
            Statement.registerOutParameter(2, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(2);

            GetPlayerInfoResponse Response = new GetPlayerInfoResponse(ResultCode);

            ResultSet Result = Statement.getResultSet();
            if (Result.getRow() > 0)
            {
                Response.PlayerID = Result.getString("player_id");
                Response.PlayerName = Result.getString("name");
                Response.PlayerEmail = Result.getString("email");
            }

            return Response;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return new GetPlayerInfoResponse(1103);
    }
}
