package Server;

import Database.MySqlRequest;
import Server.API.Utils;
import com.sun.net.httpserver.HttpContext;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class Main {
    public static int ServerPort = 8000;
    public static HttpServer httpServer;

    public static void main(String[] args) throws IOException
    {
        System.out.println("Initializing Http Server at port " + String.valueOf(ServerPort));
        InitializeServer();

        System.out.println("Creating API Handler.");
        CreateHandlerContext();


        httpServer.setExecutor(null); // creates a default executor
        httpServer.start();
        System.out.println("Http Server started at port " + String.valueOf(ServerPort));

        MySqlRequest Request = new MySqlRequest();
        //Request.GetAllCentersInCity("CityA");
    }

    public static void InitializeServer()  throws IOException
    {
        httpServer = HttpServer.create(new InetSocketAddress(ServerPort), 0);
    }

    public static void CreateHandlerContext()
    {
        HttpContext context = httpServer.createContext("/api/createbooking");
        context.setHandler( exchange ->
        {
            String RequestMethod = exchange.getRequestMethod().toString();
            if (RequestMethod.equals("POST")) {

                String Request = Utils.ConvertRequestToString(exchange.getRequestBody());


                int Result = RequestHandler.CreateBooking(Request);

                String respText = String.valueOf(Result);

                exchange.sendResponseHeaders(200, respText.getBytes().length);
                OutputStream output = exchange.getResponseBody();
                output.write(respText.getBytes());
                output.flush();
            }
            else exchange.sendResponseHeaders(405, -1);// 405 Method Not Allowed
            exchange.close();
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
