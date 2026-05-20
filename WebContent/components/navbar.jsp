<%@ page import="model.User" %>
<%@ page import="dao.NotificationDAO" %>
<%@ page import="model.Notification" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String currentURI = request.getRequestURI();
    String pageTitle = "Dashboard";
    
    if (currentURI.contains("manage-users.jsp")) {
        pageTitle = "Manage Users";
    } else if (currentURI.contains("departments.jsp")) {
        pageTitle = "Departments";
    } else if (currentURI.contains("system-settings.jsp")) {
        pageTitle = "System Settings";
    } else if (currentURI.contains("verify-requests.jsp")) {
        pageTitle = "Verification Requests";
    } else if (currentURI.contains("sarkar-updates")) {
        pageTitle = "Sarkar Updates";
    } else if (currentURI.contains("my-gunaso.jsp")) {
        pageTitle = "Mero Gunaso";
    } else if (currentURI.contains("create-gunaso.jsp")) {
        pageTitle = "Lodge Grievance";
    } else if (currentURI.contains("profile.jsp")) {
        pageTitle = "Profile Settings";
    } else if (currentURI.contains("manage-gunaso.jsp")) {
        pageTitle = "Manage Assigned Grievances";
    } else if (currentURI.contains("reports.jsp")) {
        pageTitle = "Analytics Reports";
    }
    
    // Notification Logic Initialization
    NotificationDAO notifDao = new NotificationDAO();
    int unreadCount = 0;
    List<Notification> recentNotifications = null;
    
    if (currentUser != null) {
        unreadCount = notifDao.getUnreadNotificationCount(currentUser.getId());
        recentNotifications = notifDao.getUserNotifications(currentUser.getId(), 5, 0);
    }
%>
<style>
    .notification-dropdown {
        position: relative;
        display: inline-block;
        margin-right: 20px;
    }
    .notification-icon {
        cursor: pointer;
        font-size: 1.2rem;
        position: relative;
        color: #333;
    }
    .badge {
        position: absolute;
        top: -8px;
        right: -10px;
        background-color: #e74c3c;
        color: white;
        border-radius: 50%;
        padding: 2px 6px;
        font-size: 0.7rem;
        font-weight: bold;
    }
    .notification-content {
        display: none;
        position: absolute;
        right: 0;
        background-color: #f9f9f9;
        min-width: 300px;
        box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
        z-index: 1000;
        border-radius: 5px;
        overflow: hidden;
    }
    .notification-content.show {
        display: block;
    }
    .notif-header {
        background: #2c3e50;
        color: white;
        padding: 10px 15px;
        font-weight: bold;
        display: flex;
        justify-content: space-between;
    }
    .notif-item {
        padding: 12px 15px;
        border-bottom: 1px solid #eee;
        display: flex;
        flex-direction: column;
        color: #333;
        text-decoration: none;
        transition: background 0.2s;
    }
    .notif-item:hover {
        background-color: #f1f1f1;
    }
    .notif-item.unread {
        background-color: #eaf2f8;
        font-weight: bold;
    }
    .notif-time {
        font-size: 0.75rem;
        color: #888;
        margin-top: 5px;
    }
    .notif-footer {
        padding: 10px;
        text-align: center;
        background: #eee;
    }
    .notif-footer a {
        color: #2c3e50;
        text-decoration: none;
        font-weight: bold;
        font-size: 0.9rem;
    }
</style>

<div class="top-bar">
    <div class="breadcrumb">
        <h2><%= pageTitle %></h2>
    </div>
    <div class="user-info" style="display: flex; align-items: center;">
        
        <!-- Notification Bell Integration -->
        <div class="notification-dropdown">
            <div class="notification-icon" onclick="toggleNotifications()">
                🔔
                <% if (unreadCount > 0) { %>
                    <span class="badge"><%= unreadCount %></span>
                <% } %>
            </div>
            <div class="notification-content" id="notifDropdown">
                <div class="notif-header">
                    <span>Notifications</span>
                    <% if (unreadCount > 0) { %>
                        <a href="#" style="color: #3498db; font-size: 0.8rem; text-decoration: none;" onclick="markAllRead()">Mark all read</a>
                    <% } %>
                </div>
                <% if (recentNotifications != null && !recentNotifications.isEmpty()) { 
                    for (Notification notif : recentNotifications) {
                %>
                    <a href="#" class="notif-item <%= notif.isRead() ? "" : "unread" %>">
                        <span><%= notif.getMessage() %></span>
                        <span class="notif-time"><%= notif.getCreatedAt() != null ? notif.getCreatedAt().toString() : "Just now" %></span>
                    </a>
                <%  } 
                } else { %>
                    <div style="padding: 15px; text-align: center; color: #777;">No new notifications</div>
                <% } %>
                <div class="notif-footer">
                    <a href="<%= request.getContextPath() %>/notifications.jsp">View All Notifications</a>
                </div>
            </div>
        </div>

        <span style="margin-right: 15px;">Welcome, <%= currentUser.getFullName() %> (<%= currentUser.getRoleName() %>)</span>
        <a href="<%= request.getContextPath() %>/auth/logout" class="btn" style="padding: 8px 15px; font-size: 0.8rem; width: auto;">Logout</a>
    </div>
</div>

<script>
    function toggleNotifications() {
        document.getElementById("notifDropdown").classList.toggle("show");
    }

    // Close the dropdown if the user clicks outside of it
    window.onclick = function(event) {
        if (!event.target.matches('.notification-icon') && !event.target.closest('.notification-icon')) {
            var dropdowns = document.getElementsByClassName("notification-content");
            for (var i = 0; i < dropdowns.length; i++) {
                var openDropdown = dropdowns[i];
                if (openDropdown.classList.contains('show')) {
                    openDropdown.classList.remove('show');
                }
            }
        }
    }
    
    function markAllRead() {
        // Here we would typically send an AJAX request to a MarkAllReadServlet
        // For demonstration, we'll just alert and reload or hide the badge
        alert("Marking all notifications as read...");
        // Implement AJAX call to backend here
    }
</script>
