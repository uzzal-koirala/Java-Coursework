package dao;

import model.User;
import util.DBConnection;
import util.PasswordUtil;

import java.sql.*;

public class UserDAO {

    /**
     * Registers a new user in the database.
     * 
     * @param user User object
     * @return true if successful, false otherwise
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (full_name, email, password, phone, role_id, dept_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, PasswordUtil.hashPassword(user.getPassword()));
            stmt.setString(4, user.getPhone());
            stmt.setInt(5, user.getRoleId());
            if (user.getDeptId() != null) {
                stmt.setInt(6, user.getDeptId());
            } else {
                stmt.setNull(6, java.sql.Types.INTEGER);
            }
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database connectivity issue: " + e.getMessage(), e);
        }
    }

    /**
     * Authenticates a user.
     * 
     * @param email User email
     * @param password Plain text password
     * @return User object if authenticated, null otherwise
     */
    public User loginUser(String email, String password) {
        String sql = "SELECT u.*, r.role_name FROM users u " +
                     "JOIN roles r ON u.role_id = r.id " +
                     "WHERE u.email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                if (PasswordUtil.verifyPassword(password, hashedPassword)) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setDeptId(rs.getInt("dept_id"));
                    user.setStatus(rs.getString("status"));
                    user.setRoleName(rs.getString("role_name"));
                    user.setCitizenshipNo(rs.getString("citizenship_no"));
                    user.setCitizenshipPhoto(rs.getString("citizenship_photo"));
                    user.setAvatar(rs.getString("avatar"));
                    user.setVerificationStatus(rs.getString("verification_status"));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database connectivity issue: " + e.getMessage(), e);
        }
        return null;
    }

    /**
     * Checks if email or phone already exists.
     */
    public boolean isEmailOrPhoneExists(String email, String phone) {
        String sql = "SELECT id FROM users WHERE email = ? OR phone = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, phone);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database connectivity issue: " + e.getMessage(), e);
        }
    }

    public boolean updateProfile(int userId, String citizenshipNo, String citizenshipPhoto, String avatar) {
        String sql = "UPDATE users SET citizenship_no = ?, citizenship_photo = ?, avatar = ?, verification_status = 'Pending' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, citizenshipNo);
            stmt.setString(2, citizenshipPhoto);
            stmt.setString(3, avatar);
            stmt.setInt(4, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateVerificationStatus(int userId, String status) {
        String sql = "UPDATE users SET verification_status = ? WHERE id = ?";
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

    public java.util.List<User> getPendingVerificationUsers() {
        java.util.List<User> users = new java.util.ArrayList<>();
        String sql = "SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id = r.id WHERE u.verification_status = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRoleId(rs.getInt("role_id"));
                user.setDeptId(rs.getInt("dept_id"));
                user.setStatus(rs.getString("status"));
                user.setRoleName(rs.getString("role_name"));
                user.setCitizenshipNo(rs.getString("citizenship_no"));
                user.setCitizenshipPhoto(rs.getString("citizenship_photo"));
                user.setAvatar(rs.getString("avatar"));
                user.setVerificationStatus(rs.getString("verification_status"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
}
