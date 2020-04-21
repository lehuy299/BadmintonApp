package Server.API;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

public class Utils {
    public static Map<String, String> SplitQuery(String Query) {
        Map<String, String> Parameters = new HashMap<>();

        if (Query == null || "".equals(Query)) {
            return Parameters;
        }

        if (Query.contains("&")) {
            String[] SplitQuery = Query.split("&");
            for (String Value : SplitQuery) {
                String[] KeyValue = Value.split("=");
                if (KeyValue.length == 2) {
                    Parameters.put(KeyValue[0], KeyValue[1]);
                }
            }
        }
        else
        {
            String[] KeyValue = Query.split("=");
            if (KeyValue.length == 2) {
                Parameters.put(KeyValue[0], KeyValue[1]);
            }
        }

        return Parameters;
    }

    public static String ConvertRequestToString(InputStream Input) throws IOException {
        byte [] dst  = new byte [Input.available()];
        Input.read(dst);
        return new String(dst);
    }

    private static final String ALPHA_NUMERIC_STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    public static String RandomString(int Length) {
        StringBuilder builder = new StringBuilder();
        while (Length-- != 0) {
            int character = (int)(Math.random()*ALPHA_NUMERIC_STRING.length());
            builder.append(ALPHA_NUMERIC_STRING.charAt(character));
        }
        return builder.toString();
    }
}
