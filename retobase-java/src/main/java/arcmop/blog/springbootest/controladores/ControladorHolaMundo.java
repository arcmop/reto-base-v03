package arcmop.blog.springbootest.controladores;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Map;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping
public class ControladorHolaMundo {

    @RequestMapping(value = "/sumar/{sum01}/{sum02}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody
    Map saludar(@PathVariable("sum01") Integer sum01, @PathVariable("sum02") Integer sum02) {
        String url = "jdbc:postgresql://192.168.99.100:5432/pgdatabase";
        String user = "pguser01";
        String password = "pgpassword";

        Integer resultado = null;

        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connected to the PostgreSQL server successfully.");
            resultado = sum01 + sum02;
            conn.createStatement().executeUpdate("insert into resultados(numero01,numero02,resultado) values (" + sum01 + "," + sum02 + "," + resultado + ")");
            conn.close();
            return Collections.singletonMap("resultado", String.valueOf(resultado));
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return Collections.singletonMap("resultado", String.valueOf(resultado));
    }

}
