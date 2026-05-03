package com.merosarkar.dao;

import com.merosarkar.model.Complaint;
import com.merosarkar.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {
    
    public boolean createComplaint(Complaint complaint) {
        String sql = "INSERT INTO complaints (citizen_id, official_role, subject, description, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, complaint.getCitizenId());
            stmt.setString(2, complaint.getOfficialRole());
            stmt.setString(3, complaint.getSubject());
            stmt.setString(4, complaint.getDescription());
            stmt.setString(5, complaint.getStatus() != null ? complaint.getStatus() : "PENDING");
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Complaint> getAllComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM complaints ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                complaints.add(extractComplaintFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }
    
    public List<Complaint> getComplaintsByCitizen(int citizenId) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM complaints WHERE citizen_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, citizenId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                complaints.add(extractComplaintFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    public boolean updateComplaintStatus(int id, String status) {
        String sql = "UPDATE complaints SET status = ? WHERE id = ?";
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

    public boolean deleteComplaint(int id) {
        String sql = "DELETE FROM complaints WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Complaint extractComplaintFromResultSet(ResultSet rs) throws SQLException {
        Complaint complaint = new Complaint();
        complaint.setId(rs.getInt("id"));
        complaint.setCitizenId(rs.getInt("citizen_id"));
        complaint.setOfficialRole(rs.getString("official_role"));
        complaint.setSubject(rs.getString("subject"));
        complaint.setDescription(rs.getString("description"));
        complaint.setStatus(rs.getString("status"));
        complaint.setCreatedAt(rs.getTimestamp("created_at"));
        return complaint;
    }
}
