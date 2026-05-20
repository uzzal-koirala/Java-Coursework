import java.sql.*;
import java.io.*;
import java.nio.file.*;

public class TestH2 {
    public static void main(String[] args) throws Exception {
        Class.forName("org.h2.Driver");
        String url = "jdbc:h2:./gunaso_db;MODE=MySQL;AUTO_SERVER=TRUE";
        try (Connection conn = DriverManager.getConnection(url, "sa", "");
             Statement stmt = conn.createStatement()) {
            
            String content = new String(Files.readAllBytes(Paths.get("c:/Users/Administrator/Documents/GunasoManagementSystem/GunasoManagementSystem/database/gunaso.sql")));
            for (String sql : content.split(";")) {
                sql = sql.replaceAll("--.*", "").trim();
                if (sql.isEmpty()) continue;
                try {
                    stmt.execute(sql);
                    System.out.println("SUCCESS: " + sql.substring(0, Math.min(sql.length(), 50)));
                } catch (Exception e) {
                    System.err.println("ERROR on: " + sql.substring(0, Math.min(sql.length(), 50)));
                    System.err.println(e.getMessage());
                }
            }
        }
    }
}
