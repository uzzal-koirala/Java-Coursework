package listener;

import util.DBConnection;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

/**
 * AppContextListener – runs once when Tomcat starts the web application.
 *
 * It reads database credentials from <context-param> entries in web.xml
 * and passes them to DBConnection.configure(), so credentials are never
 * hardcoded in Java source files.
 *
 * Add these to web.xml (replace values with your real DB settings):
 *
 *   <context-param>
 *       <param-name>db.url</param-name>
 *       <param-value>jdbc:mysql://localhost:3306/gunaso_db</param-value>
 *   </context-param>
 *   <context-param>
 *       <param-name>db.username</param-name>
 *       <param-value>root</param-value>
 *   </context-param>
 *   <context-param>
 *       <param-name>db.password</param-name>
 *       <param-value>yourSecurePassword</param-value>
 *   </context-param>
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();

        String url      = ctx.getInitParameter("db.url");
        String username = ctx.getInitParameter("db.username");
        String password = ctx.getInitParameter("db.password");

        DBConnection.configure(url, username, password);

        ctx.log("[AppContextListener] Database connection configured from web.xml context-params.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nothing to clean up — DriverManager connections are per-request.
    }
}
