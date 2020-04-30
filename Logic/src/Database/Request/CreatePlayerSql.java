package Database.Request;

import Database.MySqlConnection;
import Server.API.Users.Request.CreatePlayerRequest;
import Server.API.Users.Response.CreatePlayerResponse;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

public class CreatePlayerSql {
    public static CreatePlayerResponse Create(CreatePlayerRequest Request)
    {
        try {
            CallableStatement Statement = MySqlConnection.GetProcedureStatement("{Call createPlayer(?,?,?,?)}");
            Statement.setString(1, Request.PlayerID);
            Statement.setString(2, Request.PlayerName);
            Statement.setString(3, Request.PlayerEmail);
            Statement.registerOutParameter(4, Types.INTEGER);
            Statement.setQueryTimeout(10);
            Statement.execute();

            int ResultCode = Statement.getInt(4);

            CreatePlayerResponse Response = new CreatePlayerResponse(ResultCode);

            return Response;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return new CreatePlayerResponse(405);
    }
}
