package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.SarkarUpdate;
import model.UpdateComment;
import util.DBConnection;

public class SarkarUpdateDAO {

    public boolean createUpdate(SarkarUpdate update) {
        String sql = "INSERT INTO sarkar_updates (user_id, content, photo_url) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
             
            pstmt.setInt(1, update.getUserId());
            pstmt.setString(2, update.getContent());
            pstmt.setString(3, update.getPhotoUrl());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<SarkarUpdate> getAllUpdates(int currentUserId) {
        List<SarkarUpdate> updates = new ArrayList<>();
        // Query to get all updates with author info and counts
        String sql = "SELECT su.*, u.full_name, u.avatar, r.role_name, d.dept_name, " +
                     "(SELECT COUNT(*) FROM update_likes ul WHERE ul.update_id = su.id) as like_count, " +
                     "(SELECT COUNT(*) FROM update_comments uc WHERE uc.update_id = su.id) as comment_count, " +
                     "EXISTS(SELECT 1 FROM update_likes ul2 WHERE ul2.update_id = su.id AND ul2.user_id = ?) as is_liked " +
                     "FROM sarkar_updates su " +
                     "JOIN users u ON su.user_id = u.id " +
                     "JOIN roles r ON u.role_id = r.id " +
                     "LEFT JOIN departments d ON u.dept_id = d.id " +
                     "WHERE su.status = 'Active' " +
                     "ORDER BY su.created_at DESC";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
             
            pstmt.setInt(1, currentUserId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SarkarUpdate update = new SarkarUpdate();
                    update.setId(rs.getInt("id"));
                    update.setUserId(rs.getInt("user_id"));
                    update.setContent(rs.getString("content"));
                    update.setPhotoUrl(rs.getString("photo_url"));
                    update.setStatus(rs.getString("status"));
                    update.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    update.setUserFullName(rs.getString("full_name"));
                    update.setUserAvatar(rs.getString("avatar"));
                    update.setUserRoleName(rs.getString("role_name"));
                    update.setUserDeptName(rs.getString("dept_name"));
                    
                    update.setLikeCount(rs.getInt("like_count"));
                    update.setCommentCount(rs.getInt("comment_count"));
                    update.setLikedByCurrentUser(rs.getBoolean("is_liked"));
                    
                    // Fetch recent comments for this update
                    update.setComments(getCommentsForUpdate(update.getId(), 5)); // Fetch top 5 comments
                    
                    updates.add(update);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return updates;
    }

    public List<UpdateComment> getCommentsForUpdate(int updateId, int limit) {
        List<UpdateComment> comments = new ArrayList<>();
        String sql = "SELECT uc.*, u.full_name, u.avatar, r.role_name " +
                     "FROM update_comments uc " +
                     "JOIN users u ON uc.user_id = u.id " +
                     "JOIN roles r ON u.role_id = r.id " +
                     "WHERE uc.update_id = ? " +
                     "ORDER BY uc.created_at ASC"; // Oldest first for comment threads
                     
        if (limit > 0) {
            sql += " LIMIT " + limit;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
             
            pstmt.setInt(1, updateId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    UpdateComment comment = new UpdateComment();
                    comment.setId(rs.getInt("id"));
                    comment.setUpdateId(rs.getInt("update_id"));
                    comment.setUserId(rs.getInt("user_id"));
                    comment.setComment(rs.getString("comment"));
                    comment.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    comment.setUserFullName(rs.getString("full_name"));
                    comment.setUserAvatar(rs.getString("avatar"));
                    comment.setUserRoleName(rs.getString("role_name"));
                    
                    comments.add(comment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    public boolean addComment(int updateId, int userId, String comment) {
        String sql = "INSERT INTO update_comments (update_id, user_id, comment) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
             
            pstmt.setInt(1, updateId);
            pstmt.setInt(2, userId);
            pstmt.setString(3, comment);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleLike(int updateId, int userId) {
        // Check if like exists
        String checkSql = "SELECT id FROM update_likes WHERE update_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
             
            checkStmt.setInt(1, updateId);
            checkStmt.setInt(2, userId);
            
            boolean exists = false;
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    exists = true;
                }
            }
            
            if (exists) {
                // Unlike
                String deleteSql = "DELETE FROM update_likes WHERE update_id = ? AND user_id = ?";
                try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                    deleteStmt.setInt(1, updateId);
                    deleteStmt.setInt(2, userId);
                    return deleteStmt.executeUpdate() > 0; // Return true means state changed
                }
            } else {
                // Like
                String insertSql = "INSERT INTO update_likes (update_id, user_id) VALUES (?, ?)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setInt(1, updateId);
                    insertStmt.setInt(2, userId);
                    return insertStmt.executeUpdate() > 0; // Return true means state changed
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteUpdate(int updateId, int userId) {
        String deleteLikes = "DELETE FROM update_likes WHERE update_id = ?";
        String deleteComments = "DELETE FROM update_comments WHERE update_id = ?";
        String deletePost = "DELETE FROM sarkar_updates WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement pstmt1 = conn.prepareStatement(deleteLikes);
                 PreparedStatement pstmt2 = conn.prepareStatement(deleteComments);
                 PreparedStatement pstmt3 = conn.prepareStatement(deletePost)) {
                 
                 pstmt1.setInt(1, updateId);
                 pstmt1.executeUpdate();
                 
                 pstmt2.setInt(1, updateId);
                 pstmt2.executeUpdate();
                 
                 pstmt3.setInt(1, updateId);
                 pstmt3.setInt(2, userId);
                 int affected = pstmt3.executeUpdate();
                 
                 if (affected > 0) {
                     conn.commit();
                     return true;
                 } else {
                     conn.rollback();
                     return false;
                 }
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteComment(int commentId, int requestingUserId) {
        String sql = "DELETE uc FROM update_comments uc " +
                     "JOIN sarkar_updates su ON uc.update_id = su.id " +
                     "WHERE uc.id = ? AND (uc.user_id = ? OR su.user_id = ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
             
            pstmt.setInt(1, commentId);
            pstmt.setInt(2, requestingUserId);
            pstmt.setInt(3, requestingUserId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
