package Database;

import java.sql.*;

public class MySqlConnection {
    private String DbUrl;
    private String DbUsername;
    private String DbPassword;

    public MySqlConnection(String DbUrl, String DbUsername, String DbPassword)
    {
        this.DbUrl = DbUrl;
        this.DbUsername = DbUsername;
        this.DbPassword = DbPassword;
    }

    private Connection GetConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return  DriverManager.getConnection(this.DbUrl, this.DbUsername, this.DbPassword);
    }

    public CallableStatement GetProcedureStatement(String Procedure)
    {
        Connection Connection = null;
        try {
            Connection = GetConnection();
        }
        catch (ClassNotFoundException Exception) {
            System.out.println("Could not find JDBC Driver.");
            Exception.printStackTrace();
        }
        catch (SQLException Exception) {
            System.out.println("Fail to connect MySql Server.");
            Exception.printStackTrace();
        }

        CallableStatement Statement = null;
        try {
            Statement = Connection.prepareCall(Procedure);
        }
        catch (SQLException Exception) {
            System.out.println("Fail to create Statement: " + Procedure);
            Exception.printStackTrace();
        }
        return Statement;
    }
}
