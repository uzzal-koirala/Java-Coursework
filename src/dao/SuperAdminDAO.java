package dao;

import model.User;
import model.Department;
import util.DBConnection;
import util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SuperAdminDAO {

    /**
     * Retrieves overall system statistics.
     */
    public Map<String, Integer> getSystemStats() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("totalUsers", 0);
        stats.put("totalDepts", 0);
        stats.put("totalGunaso", 0);
        stats.put("solvedGunaso", 0);

        String usersSql = "SELECT COUNT(*) FROM users";
        String deptsSql = "SELECT COUNT(*) FROM departments";
        String totalGunasoSql = "SELECT COUNT(*) FROM gunaso";
        String solvedGunasoSql = "SELECT COUNT(*) FROM gunaso WHERE status = 'Solved'";

        try (Connection conn = DBConnection.getConnection()) {
            try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(usersSql)) {
                if (rs.next()) stats.put("totalUsers", rs.getInt(1));
            }
            try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(deptsSql)) {
                if (rs.next()) stats.put("totalDepts", rs.getInt(1));
            }
            try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(totalGunasoSql)) {
                if (rs.next()) stats.put("totalGunaso", rs.getInt(1));
            }
            try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(solvedGunasoSql)) {
                if (rs.next()) stats.put("solvedGunaso", rs.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Retrieves all users in the system, with roles and department names.
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name, d.dept_name FROM users u " +
                     "JOIN roles r ON u.role_id = r.id " +
                     "LEFT JOIN departments d ON u.dept_id = d.id " +
                     "ORDER BY u.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRoleId(rs.getInt("role_id"));
                u.setDeptId(rs.getInt("dept_id"));
                u.setStatus(rs.getString("status"));
                u.setRoleName(rs.getString("role_name"));
                u.setDeptName(rs.getString("dept_name"));
                u.setCitizenshipNo(rs.getString("citizenship_no"));
                u.setCitizenshipPhoto(rs.getString("citizenship_photo"));
                u.setAvatar(rs.getString("avatar"));
                u.setVerificationStatus(rs.getString("verification_status"));
                
                // Hack: We can temporarily set the department name in a customized way, or we can use another field.
                // Wait, does User model have a setDeptName method? Let's check User.java first or just set it in a transient property if present.
                // Let's assume User class has standard fields. Let's see if we can check User.java.
                // Actually, I can view User.java! Let's do that if needed, but let's assume it has standard getters/setters or we can check.
                // Wait! Let's check User.java just in case to avoid compile errors.
                users.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Toggles active/deactive status of a user.
     */
    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates user role and department assignment.
     */
    public boolean updateUserRoleAndDept(int userId, int roleId, Integer deptId) {
        String sql = "UPDATE users SET role_id = ?, dept_id = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roleId);
            if (deptId != null && deptId > 0) {
                stmt.setInt(2, deptId);
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            stmt.setInt(3, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Creates a new administrative or authority user.
     */
    public boolean createOfficialUser(User user) {
        String sql = "INSERT INTO users (full_name, email, password, phone, role_id, dept_id, status) VALUES (?, ?, ?, ?, ?, ?, 'Active')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, PasswordUtil.hashPassword(user.getPassword()));
            stmt.setString(4, user.getPhone());
            stmt.setInt(5, user.getRoleId());
            if (user.getDeptId() != null && user.getDeptId() > 0) {
                stmt.setInt(6, user.getDeptId());
            } else {
                stmt.setNull(6, java.sql.Types.INTEGER);
            }
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Dynamic system activities logs.
     */
    public List<Map<String, String>> getSystemActivities() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "(SELECT created_at, CONCAT('New user registered: ', full_name) AS activity, email AS detail FROM users) " +
                     "UNION " +
                     "(SELECT created_at, CONCAT('New complaint filed: ', title) AS activity, status AS detail FROM gunaso) " +
                     "UNION " +
                     "(SELECT created_at, CONCAT('Reply added to ticket #', gunaso_id) AS activity, LEFT(message, 50) AS detail FROM replies) " +
                     "ORDER BY created_at DESC LIMIT 10";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, String> map = new HashMap<>();
                map.put("time", rs.getTimestamp("created_at").toString());
                map.put("activity", rs.getString("activity"));
                map.put("detail", rs.getString("detail"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // -----------------------------------------------------------------------
    // Department CRUD
    // -----------------------------------------------------------------------

    public boolean addDepartment(String name) {
        String sql = "INSERT INTO departments (dept_name) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateDepartment(int id, String name) {
        String sql = "UPDATE departments SET dept_name = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteDepartment(int id) {
        String sql = "DELETE FROM departments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get the count of officers assigned to a department
     */
    public Map<Integer, Integer> getDepartmentOfficerCounts() {
        Map<Integer, Integer> counts = new HashMap<>();
        String sql = "SELECT dept_id, COUNT(*) FROM users WHERE dept_id IS NOT NULL GROUP BY dept_id";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                counts.put(rs.getInt(1), rs.getInt(2));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return counts;
    }

    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
