package Server;

import Server.API.Utils;
import com.sun.net.httpserver.BasicAuthenticator;
import com.sun.net.httpserver.HttpContext;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class Main {
    public static int ServerPort = 8000;
    public static HttpServer httpServer;

    public static void main(String[] args) throws IOException {
        InitializeServer();
        System.out.println("Initialized Http Server");

        InitializeCreateBookingContext();
        System.out.println("Initialized CreateBooking Context.");

        InitializeGetCourtBookingContext();
        System.out.println("Initialized GetCourtBooking Context.");

        httpServer.setExecutor(null); // creates a default executor
        httpServer.start();
        System.out.println("Http Server started at port " + String.valueOf(ServerPort));
    }

    public static void InitializeServer()  throws IOException {
        httpServer = HttpServer.create(new InetSocketAddress(ServerPort), 0);
    }

    public static void InitializeCreateBookingContext() {
        HttpContext Context = httpServer.createContext("/api/createbooking");
        Context.setAuthenticator(new BasicAuthenticator("get") {
            @Override
            public boolean checkCredentials(String User, String SecretKey) {
                return User.equals("user") && SecretKey.equals("123456");
            }
        });

        Context.setHandler(Handler ->
        {
            String RequestMethod = Handler.getRequestMethod().toString();
            if (RequestMethod.equals("POST")) {
                String Request = Utils.ConvertRequestToString(Handler.getRequestBody());

                String ResultString = RequestHandler.CreateBooking(Request);

                String ResponseData = "Result=" + String.valueOf(ResultString);

                Handler.sendResponseHeaders(200, ResponseData.getBytes().length);
                OutputStream output = Handler.getResponseBody();
                output.write(ResponseData.getBytes());
                output.flush();
            }
            else Handler.sendResponseHeaders(405, -1);// 405 Method Not Allowed
            Handler.close();
        });
    }

    public static void InitializeGetCourtBookingContext() {
        HttpContext Context = httpServer.createContext("/api/getcourtbooking");
        Context.setAuthenticator(new BasicAuthenticator("get") {
            @Override
            public boolean checkCredentials(String User, String SecretKey) {
                return User.equals("user") && SecretKey.equals("123456");
            }
        });

        Context.setHandler(Handler ->
        {
            String RequestMethod = Handler.getRequestMethod().toString();
            if (RequestMethod.equals("GET")) {
                String Request = Utils.ConvertRequestToString(Handler.getRequestBody());

                String ResultString = RequestHandler.GetCourtBooking(Request);

                String ResponseData =  "Result=" + String.valueOf(ResultString);

                Handler.sendResponseHeaders(200, ResponseData.getBytes().length);
                OutputStream output = Handler.getResponseBody();
                output.write(ResponseData.getBytes());
                output.flush();
            }
            else Handler.sendResponseHeaders(405, -1);// 405 Method Not Allowed
            Handler.close();
        });
    }

    public static void CreateTestContext()
    {
        HttpContext context = httpServer.createContext("/api/hello");
        //context.setAuthenticator(new BasicAuthenticator("get") {
        //    @Override
        //    public boolean checkCredentials(String user, String pwd) {
        //        System.out.println(user);
        //        System.out.println(pwd);
        //        return user.equals("admin") && pwd.equals("admin");
        //    }
        //});
        context.setHandler( exchange ->
        {
            String RequestMethod = exchange.getRequestMethod();
            switch (RequestMethod) {
                case "GET":
                    System.out.println(exchange.getRequestURI().getQuery());

                    String respText = String.format("Hello %s!", "name");

                    exchange.sendResponseHeaders(200, respText.getBytes().length);
                    OutputStream output = exchange.getResponseBody();
                    output.write(respText.getBytes());
                    output.flush();

                    break;
                default:
                    exchange.sendResponseHeaders(405, -1);// 405 Method Not Allowed
            }
            exchange.close();
        });
    }


}
