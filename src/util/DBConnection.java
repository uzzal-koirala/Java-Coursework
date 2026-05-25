package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection – provides a fresh JDBC connection per call.
 *
 * SECURITY NOTES:
 *   1. Credentials are NOT hardcoded here. They are read from web.xml
 *      context-params (db.url, db.username, db.password) by the
 *      AppContextListener at startup and stored in this class.
 *   2. Every DAO opens its own connection and closes it in a try-with-resources
 *      block, so there is no shared mutable state between requests.
 *   3. SSL is enabled by default (do not add useSSL=false in production).
 */
public class DBConnection {

    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    // Set once at application startup by AppContextListener via web.xml params.
    // Never hard-code real values here.
    private static String dbUrl      = "jdbc:mysql://localhost:3306/gunaso_db";
    private static String dbUsername = "root";
    private static String dbPassword = "";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(
                "MySQL JDBC driver not found. Add mysql-connector-j.jar to /WEB-INF/lib. " + e.getMessage());
        }
    }

    /** Called once by AppContextListener with values from web.xml context-params. */
    public static void configure(String url, String username, String password) {
        if (url != null && !url.isEmpty())      dbUrl      = url;
        if (username != null)                   dbUsername = username;
        if (password != null)                   dbPassword = password;
    }

    /**
     * Returns a brand-new connection for the caller.
     * The caller MUST close it (use try-with-resources).
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
    }

    // Prevent instantiation
    private DBConnection() {}
}


// Done by Kiran Bardewa