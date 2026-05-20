package dao;

import model.Notification;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    /**
     * Inserts a new notification into the database.
     * This method handles the creation of a notification record for a specific user.
     *
     * @param notification The notification object to be inserted.
     * @return true if the insertion was successful, false otherwise.
     */
    public boolean createNotification(Notification notification) {
        String sql = "INSERT INTO notifications (user_id, message, is_read, created_at) VALUES (?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, notification.getUserId());
            stmt.setString(2, notification.getMessage());
            stmt.setBoolean(3, notification.isRead());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error creating notification: " + e.getMessage());
            return false;
        }
    }

    /**
     * Retrieves all notifications for a specific user, ordered by creation date descending.
     * Includes pagination support.
     *
     * @param userId The ID of the user.
     * @param limit The maximum number of notifications to retrieve.
     * @param offset The offset for pagination.
     * @return A list of Notification objects.
     */
    public List<Notification> getUserNotifications(int userId, int limit, int offset) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            stmt.setInt(3, offset);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Notification notification = extractNotificationFromResultSet(rs);
                    notifications.add(notification);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error retrieving user notifications: " + e.getMessage());
        }
        return notifications;
    }

    /**
     * Retrieves all unread notifications for a specific user.
     *
     * @param userId The ID of the user.
     * @return A list of unread Notification objects.
     */
    public List<Notification> getUnreadNotifications(int userId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? AND is_read = FALSE ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Notification notification = extractNotificationFromResultSet(rs);
                    notifications.add(notification);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error retrieving unread notifications: " + e.getMessage());
        }
        return notifications;
    }

    /**
     * Gets the count of unread notifications for a specific user.
     * Useful for displaying badge counts on the UI.
     *
     * @param userId The ID of the user.
     * @return The count of unread notifications.
     */
    public int getUnreadNotificationCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error getting unread notification count: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Marks a specific notification as read.
     *
     * @param notificationId The ID of the notification to mark as read.
     * @return true if successful, false otherwise.
     */
    public boolean markAsRead(int notificationId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, notificationId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error marking notification as read: " + e.getMessage());
            return false;
        }
    }

    /**
     * Marks all unread notifications for a specific user as read.
     * This is a batch operation often triggered by a "Mark all as read" button.
     *
     * @param userId The ID of the user.
     * @return The number of notifications marked as read.
     */
    public int markAllAsReadForUser(int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            return stmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error marking all notifications as read: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Deletes a specific notification from the database.
     *
     * @param notificationId The ID of the notification to delete.
     * @return true if successful, false otherwise.
     */
    public boolean deleteNotification(int notificationId) {
        String sql = "DELETE FROM notifications WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, notificationId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error deleting notification: " + e.getMessage());
            return false;
        }
    }

    /**
     * Deletes all notifications for a specific user older than a specified number of days.
     * Useful for database cleanup and maintenance tasks.
     *
     * @param userId The ID of the user.
     * @param daysOlderThan The threshold in days.
     * @return The number of deleted notifications.
     */
    public int deleteOldNotifications(int userId, int daysOlderThan) {
        String sql = "DELETE FROM notifications WHERE user_id = ? AND created_at < DATE_SUB(NOW(), INTERVAL ? DAY)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, daysOlderThan);
            return stmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error deleting old notifications: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Utility method to extract a Notification object from a ResultSet.
     * This reduces code duplication in retrieval methods.
     *
     * @param rs The ResultSet positioned at the current row.
     * @return A populated Notification object.
     * @throws SQLException If a database access error occurs.
     */
    private Notification extractNotificationFromResultSet(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setId(rs.getInt("id"));
        notification.setUserId(rs.getInt("user_id"));
        notification.setMessage(rs.getString("message"));
        notification.setRead(rs.getBoolean("is_read"));
        notification.setCreatedAt(rs.getTimestamp("created_at"));
        return notification;
    }
}
