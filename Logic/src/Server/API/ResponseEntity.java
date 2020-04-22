package Server.API;

import com.sun.net.httpserver.Headers;

import lombok.Value;

@Value
public class ResponseEntity<T> {
    public ResponseEntity(int StatusCode, Headers Headers, T Body) {
        this.StatusCode = StatusCode;
        this.Headers = Headers;
        this.Body = Body;
    }
    public int GetStatusCode() { return this.StatusCode; }
    public Headers GetHeaders() { return this.Headers; }
    public T GetBody() { return this.Body; }

    private final Headers Headers;
    private final int StatusCode;
    private final T Body;

}