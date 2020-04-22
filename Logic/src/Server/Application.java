package Server;

import Database.MySqlConnection;
import Server.API.Users.Handler.CreateBookingHandler;
import Server.API.Users.Handler.GetCourtBookingHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.sql.SQLException;

import static Server.Configuration.GlobalExceptionHandler;
import static Server.Configuration.ObjectMapper;

public class Application {
    private static int ServerPort = 8001;
    private static String DbUrl = "jdbc:mysql://localhost:3306/booking_app";
    private static String DbUsername = "root";
    private static String DbPassword = "teamdpe2020";

    public static HttpServer httpServer;

    public static void main(String[] args) throws IOException {
        try
        {
            InitializeServer();
            System.out.println("Initialized Http Server.");

            InitializeCreateBookingContext();
            System.out.println("Initialized CreateBooking Context.");

            InitializeGetCourtBookingContext();
            System.out.println("Initialize GetCourtBooking Context.");

            OpenMySqlConnection();
            System.out.println("Initialized MySql Connection.");

            httpServer.setExecutor(null); // creates a default executor
            httpServer.start();
            System.out.println("Http Server started at port " + String.valueOf(ServerPort));
        }
        catch (Exception Exception)
        {
            Exception.printStackTrace();
        }
    }

    public static void InitializeServer()  throws IOException {
        httpServer = HttpServer.create(new InetSocketAddress(ServerPort), 0);
    }

    public static void OpenMySqlConnection() throws SQLException, ClassNotFoundException {
        MySqlConnection.OpenConnection(DbUrl, DbUsername, DbPassword);
    }

    public static void InitializeCreateBookingContext() {
        CreateBookingHandler CreateBookingHandler = new CreateBookingHandler("POST", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/createbooking", CreateBookingHandler::Handle);
    }

    public static void InitializeGetCourtBookingContext() {
        GetCourtBookingHandler GetCourtBookingHandler = new GetCourtBookingHandler("GET", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/getcourtbooking", GetCourtBookingHandler::Handle);
    }
}