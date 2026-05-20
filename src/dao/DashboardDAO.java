package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import util.DBConnection;

public class DashboardDAO {

    /**
     * Gets a summary of complaints grouped by status for a specific user.
     */
    public Map<String, Integer> getUserGunasoSummary(int userId) {
        Map<String, Integer> summary = new HashMap<>();
        summary.put("Pending", 0);
        summary.put("In Review", 0);
        summary.put("Solved", 0);
        summary.put("Rejected", 0);

        String sql = "SELECT status, COUNT(*) as count FROM gunaso WHERE user_id = ? GROUP BY status";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("status");
                    int count = rs.getInt("count");
                    summary.put(status, count);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return summary;
    }

    /**
     * Gets a summary of all complaints grouped by status for administrative views.
     */
    public Map<String, Integer> getAdminGunasoSummary() {
        Map<String, Integer> summary = new HashMap<>();
        summary.put("Pending", 0);
        summary.put("In Review", 0);
        summary.put("Solved", 0);
        summary.put("Rejected", 0);

        String sql = "SELECT status, COUNT(*) as count FROM gunaso GROUP BY status";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");
                summary.put(status, count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return summary;
    }

    /**
     * Retrieves recent activities or updates for the dashboard timeline.
     * Combines multiple tables to provide a comprehensive activity feed.
     */
    public List<Map<String, Object>> getRecentActivities(int limit) {
        List<Map<String, Object>> activities = new ArrayList<>();

        // This is a comprehensive query to pull recent actions across the platform.
        String sql = "(SELECT 'New Complaint' as type, title as description, created_at FROM gunaso) " +
                "UNION ALL " +
                "(SELECT 'New Reply' as type, LEFT(message, 50) as description, created_at FROM replies) " +
                "UNION ALL " +
                "(SELECT 'System Update' as type, LEFT(content, 50) as description, created_at FROM sarkar_updates) " +
                "ORDER BY created_at DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> activity = new HashMap<>();
                    activity.put("type", rs.getString("type"));
                    activity.put("description", rs.getString("description"));
                    activity.put("createdAt", rs.getTimestamp("created_at"));
                    activities.add(activity);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }

    /**
     * Calculates the resolution rate for complaints over the last 30 days.
     * Useful for charting performance metrics on the dashboard.
     */
    public double getMonthlyResolutionRate() {
        double rate = 0.0;
        String sqlTotal = "SELECT COUNT(*) FROM gunaso WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
        String sqlSolved = "SELECT COUNT(*) FROM gunaso WHERE status = 'Solved' AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";

        try (Connection conn = DBConnection.getConnection()) {
            int total = 0;
            int solved = 0;

            try (Statement stmt1 = conn.createStatement(); ResultSet rs1 = stmt1.executeQuery(sqlTotal)) {
                if (rs1.next()) {
                    total = rs1.getInt(1);
                }
            }

            try (Statement stmt2 = conn.createStatement(); ResultSet rs2 = stmt2.executeQuery(sqlSolved)) {
                if (rs2.next()) {
                    solved = rs2.getInt(1);
                }
            }

            if (total > 0) {
                rate = ((double) solved / total) * 100.0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rate;
    }

    /**
     * Gets a breakdown of complaints by department.
     */
    public Map<String, Integer> getComplaintsByDepartment() {
        Map<String, Integer> deptStats = new HashMap<>();
        String sql = "SELECT d.dept_name, COUNT(g.id) as count " +
                "FROM departments d " +
                "LEFT JOIN gunaso g ON d.id = g.dept_id " +
                "GROUP BY d.id, d.dept_name " +
                "ORDER BY count DESC";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                deptStats.put(rs.getString("dept_name"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return deptStats;
    }

    /**
     * Gets the count of active users in the system.
     */
    public int getActiveUserCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'Active'";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Computes the average response time for complaints (in hours).
     * This is a complex analytical query for the dashboard.
     */
    public double getAverageResponseTimeHours() {
        String sql = "SELECT AVG(TIMESTAMPDIFF(HOUR, g.created_at, r.created_at)) as avg_hours " +
                "FROM gunaso g " +
                "JOIN (SELECT gunaso_id, MIN(created_at) as created_at FROM replies GROUP BY gunaso_id) r " +
                "ON g.id = r.gunaso_id";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getDouble("avg_hours");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}
