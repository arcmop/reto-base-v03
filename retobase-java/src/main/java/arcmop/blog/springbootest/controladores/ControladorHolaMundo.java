package arcmop.blog.springbootest.controladores;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping
public class ControladorHolaMundo {

    @Value(value = "#{environment.PG_USER}")
    private String pgUser;

    @Value(value = "#{environment.PG_PWD}")
    private String pgPwd;

    @Value(value = "#{environment.PG_DB}")
    private String pgDB;

    @Value(value = "#{environment.PG_SERVER}")
    private String pgServer;

    @Value(value = "#{environment.PG_SERVER_PORT}")
    private String pgServerPort;

    @CrossOrigin(origins = "*")
    @RequestMapping(value = "/sumar/{sum01}/{sum02}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody
    Map saludar(@PathVariable("sum01") Integer sum01, @PathVariable("sum02") Integer sum02) {
        String urlBase = "jdbc:postgresql://%1$s:%2$s/%3$s";
        String query = "insert into resultados(numero01,numero02,resultado) values ( %1$s, %2$s, %3$s)";

        boolean wasInserted = false;
        Integer operationResult = null;
        Map<String, String> methodResult = new HashMap<String, String>();

        Connection conn = null;
        String urlEnd = String.format(urlBase, pgServer, pgServerPort, pgDB);

        try {
            InetAddress ip = InetAddress.getLocalHost();
            String hostname = ip.getHostName();
            methodResult.put("hostname", hostname);

            conn = DriverManager.getConnection(urlEnd, pgUser, pgPwd);
            System.out.println("Connected to the PostgreSQL server successfully.");
            operationResult = sum01 + sum02;
            methodResult.put("resultado", String.valueOf(operationResult));

            conn.createStatement().executeUpdate(String.format(query, sum01.toString(), sum02.toString(), operationResult.toString()));
            conn.close();
            wasInserted = true;

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        methodResult.put("insertado", String.valueOf(wasInserted));

        return methodResult;
    }
}
