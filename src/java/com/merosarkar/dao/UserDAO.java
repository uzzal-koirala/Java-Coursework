package com.merosarkar.dao;

import com.merosarkar.model.User;
import com.merosarkar.util.DBConnection;
import com.merosarkar.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (full_name, phone_number, password_hash, role, profile_pic) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhoneNumber());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getProfilePic());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User validateLogin(String phoneNumber, String plainPassword) {
        String sql = "SELECT * FROM users WHERE phone_number = ? AND password_hash = ? AND status != 'BLOCKED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, phoneNumber);
            stmt.setString(2, PasswordUtil.hashPassword(plainPassword));
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User getUserByPhone(String phoneNumber) {
        String sql = "SELECT * FROM users WHERE phone_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, phoneNumber);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean updateUserStatus(int id, String status) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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

    public boolean updateUserDetails(int id, String fullName, String phoneNumber, String role, String password) {
        StringBuilder sql = new StringBuilder("UPDATE users SET full_name = ?, phone_number = ?");
        if (role != null) sql.append(", role = ?");
        if (password != null && !password.isEmpty()) sql.append(", password_hash = ?");
        sql.append(" WHERE id = ?");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            int idx = 1;
            stmt.setString(idx++, fullName);
            stmt.setString(idx++, phoneNumber);
            if (role != null) stmt.setString(idx++, role);
            if (password != null && !password.isEmpty()) stmt.setString(idx++, PasswordUtil.hashPassword(password));
            stmt.setInt(idx++, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createUserAdmin(User user) {
        String sql = "INSERT INTO users (full_name, phone_number, password_hash, role, status, profile_pic) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhoneNumber());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getStatus() != null ? user.getStatus() : "APPROVED");
            stmt.setString(6, user.getProfilePic());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFullName(rs.getString("full_name"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setProfilePic(rs.getString("profile_pic"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
