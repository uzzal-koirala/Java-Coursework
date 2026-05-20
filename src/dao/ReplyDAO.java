package dao;

import model.Reply;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReplyDAO {

    public boolean addReply(Reply reply) {
        String sql = "INSERT INTO replies (gunaso_id, user_id, message) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reply.getGunasoId());
            stmt.setInt(2, reply.getUserId());
            stmt.setString(3, reply.getMessage());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Reply> getRepliesByGunasoId(int gunasoId) {
        List<Reply> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name as user_name, ro.role_name " +
                     "FROM replies r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN roles ro ON u.role_id = ro.id " +
                     "WHERE r.gunaso_id = ? ORDER BY r.created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, gunasoId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Reply r = new Reply();
                r.setId(rs.getInt("id"));
                r.setGunasoId(rs.getInt("gunaso_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setMessage(rs.getString("message"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setUserName(rs.getString("user_name"));
                r.setRoleName(rs.getString("role_name"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
