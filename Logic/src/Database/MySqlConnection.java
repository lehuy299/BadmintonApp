package Database;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MySqlConnection {
    private static Connection CurrentConnection;

    public static void OpenConnection(String DbUrl, String DbUsername, String DbPassword) throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");

        CurrentConnection = DriverManager.getConnection(DbUrl, DbUsername, DbPassword);
    }

    public static CallableStatement GetProcedureStatement(String Procedure)
    {
        CallableStatement Statement = null;
        try {
            Statement = CurrentConnection.prepareCall(Procedure);
        }
        catch (SQLException Exception) {
            System.out.println("Fail to create Statement: " + Procedure);
            Exception.printStackTrace();
        }
        return Statement;
    }
}
