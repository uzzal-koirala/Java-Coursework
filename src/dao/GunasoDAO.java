package dao;

import model.Gunaso;
import model.Department;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GunasoDAO {

    public boolean addGunaso(Gunaso gunaso) {
        String sql = "INSERT INTO gunaso (title, description, user_id, dept_id, attachment) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, gunaso.getTitle());
            stmt.setString(2, gunaso.getDescription());
            stmt.setInt(3, gunaso.getUserId());
            stmt.setInt(4, gunaso.getDeptId());
            stmt.setString(5, gunaso.getAttachment());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Gunaso> getGunasoByUserId(int userId) {
        List<Gunaso> list = new ArrayList<>();
        String sql = "SELECT g.*, d.dept_name FROM gunaso g JOIN departments d ON g.dept_id = d.id WHERE g.user_id = ? ORDER BY g.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Gunaso g = mapResultSetToGunaso(rs);
                g.setDeptName(rs.getString("dept_name"));
                list.add(g);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Gunaso> getGunasoByDeptId(int deptId) {
        List<Gunaso> list = new ArrayList<>();
        String sql = "SELECT g.*, u.full_name as user_name FROM gunaso g JOIN users u ON g.user_id = u.id WHERE g.dept_id = ? ORDER BY g.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, deptId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Gunaso g = mapResultSetToGunaso(rs);
                g.setUserName(rs.getString("user_name"));
                list.add(g);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int gunasoId, String status) {
        String sql = "UPDATE gunaso SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, gunasoId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM departments";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Department(rs.getInt("id"), rs.getString("dept_name")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Gunaso getGunasoById(int id) {
        String sql = "SELECT g.*, d.dept_name, u.full_name as user_name FROM gunaso g " +
                     "JOIN departments d ON g.dept_id = d.id " +
                     "JOIN users u ON g.user_id = u.id " +
                     "WHERE g.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Gunaso g = mapResultSetToGunaso(rs);
                g.setDeptName(rs.getString("dept_name"));
                g.setUserName(rs.getString("user_name"));
                return g;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Gunaso> getAllGunasos() {
        List<Gunaso> list = new ArrayList<>();
        String sql = "SELECT g.*, d.dept_name, u.full_name as user_name FROM gunaso g " +
                     "JOIN departments d ON g.dept_id = d.id " +
                     "JOIN users u ON g.user_id = u.id " +
                     "ORDER BY g.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Gunaso g = mapResultSetToGunaso(rs);
                g.setDeptName(rs.getString("dept_name"));
                g.setUserName(rs.getString("user_name"));
                list.add(g);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Gunaso mapResultSetToGunaso(ResultSet rs) throws SQLException {
        Gunaso g = new Gunaso();
        g.setId(rs.getInt("id"));
        g.setTitle(rs.getString("title"));
        g.setDescription(rs.getString("description"));
        g.setUserId(rs.getInt("user_id"));
        g.setDeptId(rs.getInt("dept_id"));
        g.setStatus(rs.getString("status"));
        g.setAttachment(rs.getString("attachment"));
        g.setCreatedAt(rs.getTimestamp("created_at"));
        g.setUpdatedAt(rs.getTimestamp("updated_at"));
        return g;
    }
}
// Done by Rojina