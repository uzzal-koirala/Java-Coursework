package util;

import java.io.File;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DBInitializer {

    public static void initialize(jakarta.servlet.ServletContext ctx, String dbUrl, String username, String password) {
        String rootDbUrl = dbUrl;
        if (!dbUrl.contains("h2") && dbUrl.contains("/gunaso_db")) {
            rootDbUrl = dbUrl.replace("/gunaso_db", "/");
        }

        try {
            Class.forName(dbUrl.contains("h2") ? "org.h2.Driver" : "com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(rootDbUrl, username, password);
                 Statement stmt = conn.createStatement()) {
                 
                if (!dbUrl.contains("h2")) {
                    // Create database (MySQL only)
                    stmt.execute("CREATE DATABASE IF NOT EXISTS gunaso_db");
                    ctx.log("Database 'gunaso_db' checked/created.");
                    
                    // Use database
                    stmt.execute("USE gunaso_db");
                }
                
                String webContentPath = ctx.getRealPath("/");
                
                // Read and execute gunaso.sql
                File gunasoSql = new File(webContentPath, "../database/gunaso.sql");
                if (!gunasoSql.exists()) {
                    gunasoSql = new File("c:/Users/Administrator/Documents/GunasoManagementSystem/GunasoManagementSystem/database/gunaso.sql");
                }
                if (gunasoSql.exists()) {
                    executeSqlScript(stmt, gunasoSql);
                    ctx.log("Executed gunaso.sql successfully.");
                } else {
                    ctx.log("Could not find database/gunaso.sql at: " + gunasoSql.getAbsolutePath());
                }
                
                // Read and execute seed_gov_users.sql
                File seedSql = new File(webContentPath, "../seed_gov_users.sql");
                if (!seedSql.exists()) {
                    seedSql = new File("c:/Users/Administrator/Documents/GunasoManagementSystem/GunasoManagementSystem/seed_gov_users.sql");
                }
                if (seedSql.exists()) {
                    executeSqlScript(stmt, seedSql);
                    ctx.log("Executed seed_gov_users.sql successfully.");
                    
                    // Fix SuperAdmin password programmatically to ensure hash is 100% correct
                    String correctHash = util.PasswordUtil.hashPassword("Admin123!");
                    stmt.execute("UPDATE users SET password = '" + correctHash + "' WHERE email = 'superadmin@gunaso.gov.np'");
                    ctx.log("Updated SuperAdmin password hash programmatically.");
                } else {
                    ctx.log("Could not find seed_gov_users.sql at: " + seedSql.getAbsolutePath());
                }
                
            }
        } catch (Exception e) {
            ctx.log("DB Initialization Error: " + e.getMessage(), e);
        }
    }

    private static void executeSqlScript(Statement stmt, File sqlFile) throws Exception {
        String content = new String(Files.readAllBytes(sqlFile.toPath()));
        String[] statements = content.split(";");
        for (String sql : statements) {
            if (sql.trim().isEmpty()) continue;
            // Basic cleanup to remove comments which might cause issues
            String cleanSql = sql.replaceAll("--.*", "").trim();
            if (!cleanSql.isEmpty()) {
                try {
                    stmt.execute(cleanSql);
                } catch (Exception e) {
                    System.err.println("Error executing: " + cleanSql);
                    System.err.println(e.getMessage());
                }
            }
        }
    }
}
