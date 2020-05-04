package Server;

import Database.MySqlConnection;
import Server.API.Users.Handler.*;
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

            InitializeCancelBookingContext();
            InitializeCreateBookingContext();
            InitializeCreateCityCenterCourtContext();
            InitializeCreateCityCenterContext();
            InitializeCreateCityContext();
            InitializeCreatePlayerContext();
            InitializeGetAllCenterInCityContext();
            InitializeGetAllCityContext();
            InitializeGetAllCourtInCenterContext();
            InitializeGetAvalableSlotContext();
            InitializeGetCourtBookingContext();
            InitializeGetPlayerInfoContext();

            OpenMySqlConnection();

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
        System.out.println("Initialized Http Server.");
    }

    public static void OpenMySqlConnection() throws SQLException, ClassNotFoundException {
        MySqlConnection.OpenConnection(DbUrl, DbUsername, DbPassword);
        System.out.println("Initialized MySql Connection.");
    }

    public static void InitializeCreateBookingContext() {
        CreateBookingHandler CreateBookingHandler = new CreateBookingHandler("POST", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/createbooking", CreateBookingHandler::Handle);
        System.out.println("Initialized CreateBooking Context.");
    }

    public static void InitializeGetCourtBookingContext() {
        GetCourtBookingHandler GetCourtBookingHandler = new GetCourtBookingHandler("GET", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/getcourtbooking", GetCourtBookingHandler::Handle);
        System.out.println("Initialize GetCourtBooking Context.");
    }

    public static void InitializeGetAvalableSlotContext() {
        GetAvalableSlotHandler GetAvalableSlotHandler = new GetAvalableSlotHandler("GET", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/getavalableslot", GetAvalableSlotHandler::Handle);
        System.out.println("Initialize GetAvalableSlot Context.");
    }

    public static void InitializeCancelBookingContext() {
        CancelBookingHandler CancelBookingHandler = new CancelBookingHandler("POST", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/cancelbooking", CancelBookingHandler::Handle);
        System.out.println("Initialize CancelBooking Context.");
    }

    public static void InitializeCreateCityCenterCourtContext() {
        CreateCityCenterCourtHandler CreateCityCenterCourtHandler = new CreateCityCenterCourtHandler("POST", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/createcitycentercourt", CreateCityCenterCourtHandler::Handle);
        System.out.println("Initialize CreateCityCenter Context.");
    }

    public static void InitializeCreateCityCenterContext() {
        CreateCityCenterHandler CreateCityCenterHandler = new CreateCityCenterHandler("POST", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/createcitycenter", CreateCityCenterHandler::Handle);
        System.out.println("Initialize CreateCityCenter Context.");
    }

    public static void InitializeCreateCityContext() {
        CreateCityHandler CreateCityHandler = new CreateCityHandler("POST", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/createcity", CreateCityHandler::Handle);
        System.out.println("Initialize CreateCity Context.");
    }

    public static void InitializeCreatePlayerContext() {
        CreatePlayerHandler CreatePlayerHandler = new CreatePlayerHandler("POST", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/createplayer", CreatePlayerHandler::Handle);
        System.out.println("Initialize CreatePlayer Context.");
    }

    public static void InitializeGetAllCenterInCityContext() {
        GetAllCenterInCityHandler GetAllCenterInCityHandler = new GetAllCenterInCityHandler("GET", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/getallcenterincity", GetAllCenterInCityHandler::Handle);
        System.out.println("Initialize GetAllCenterInCity Context.");
    }

    public static void InitializeGetAllCityContext() {
        GetAllCityHandler GetAllCityHandler = new GetAllCityHandler("GET", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/getallcity", GetAllCityHandler::Handle);
        System.out.println("Initialize GetAllCity Context.");
    }

    public static void InitializeGetAllCourtInCenterContext() {
        GetAllCourtInCenterHandler GetAllCourtInCenterHandler = new GetAllCourtInCenterHandler("GET", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/getallcourtincenter", GetAllCourtInCenterHandler::Handle);
        System.out.println("Initialize GetAllCourtInCenter Context.");
    }

    public static void InitializeGetPlayerInfoContext() {
        GetPlayerInfoHandler GetPlayerInfoHandler = new GetPlayerInfoHandler("GET", ObjectMapper, GlobalExceptionHandler);
        httpServer.createContext("/api/users/getplayerinfo", GetPlayerInfoHandler::Handle);
        System.out.println("Initialize GetPlayerInfo Context.");
    }
}
