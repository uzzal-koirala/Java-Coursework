package service;

import dao.NotificationDAO;
import model.Notification;
import java.util.List;

public class NotificationService {
    
    private NotificationDAO notificationDAO;

    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
    }

    /**
     * Send a notification to a user.
     * This method validates the input and handles exceptions robustly.
     * 
     * @param userId The recipient user ID.
     * @param message The notification content.
     * @return true if successfully dispatched.
     */
    public boolean sendNotification(int userId, String message) {
        if (userId <= 0 || message == null || message.trim().isEmpty()) {
            return false;
        }
        
        Notification notif = new Notification();
        notif.setUserId(userId);
        notif.setMessage(message);
        notif.setRead(false);
        
        return notificationDAO.createNotification(notif);
    }
    
    /**
     * Notify a user about a status change on their Gunaso (Grievance).
     */
    public boolean notifyGunasoStatusChange(int userId, int gunasoId, String newStatus) {
        String message = "Your Gunaso #" + gunasoId + " has been updated to: " + newStatus + ".";
        return sendNotification(userId, message);
    }

    /**
     * Notify an authority that a new Gunaso has been assigned to their department.
     */
    public boolean notifyNewGunasoAssignment(int authorityId, int gunasoId, String gunasoTitle) {
        String message = "New Grievance Assigned: #" + gunasoId + " - " + gunasoTitle;
        return sendNotification(authorityId, message);
    }

    /**
     * Notify user of a new reply to their Gunaso.
     */
    public boolean notifyNewReply(int userId, int gunasoId) {
        String message = "You have received a new reply on your Gunaso #" + gunasoId + ".";
        return sendNotification(userId, message);
    }
    
    /**
     * System level broadcast notification (loops through users).
     * In a real enterprise system this would use batch processing.
     */
    public int broadcastSystemUpdate(List<Integer> userIds, String updateTitle) {
        int successCount = 0;
        String message = "System Update: " + updateTitle;
        for (Integer uid : userIds) {
            if (sendNotification(uid, message)) {
                successCount++;
            }
        }
        return successCount;
    }

    public List<Notification> getRecentNotifications(int userId, int limit) {
        if (userId <= 0 || limit <= 0) {
            return null;
        }
        return notificationDAO.getUserNotifications(userId, limit, 0);
    }
    
    public List<Notification> getAllNotifications(int userId, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return notificationDAO.getUserNotifications(userId, pageSize, offset);
    }
    
    public int getUnreadCount(int userId) {
        return notificationDAO.getUnreadNotificationCount(userId);
    }
    
    public boolean markNotificationRead(int notificationId) {
        return notificationDAO.markAsRead(notificationId);
    }
    
    public int markAllRead(int userId) {
        return notificationDAO.markAllAsReadForUser(userId);
    }
    
    public int cleanupOldNotifications(int userId, int daysOld) {
        return notificationDAO.deleteOldNotifications(userId, daysOld);
    }
}
