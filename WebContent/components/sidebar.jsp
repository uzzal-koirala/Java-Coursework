<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    String role = (user != null) ? user.getRoleName() : "CITIZEN";
    String fullName = (user != null) ? user.getFullName() : "Demo User";
    String initials = "DU";
    if(user != null && fullName != null && !fullName.isEmpty()) {
        String[] parts = fullName.split(" ");
        if(parts.length > 1) {
            initials = parts[0].substring(0, 1) + parts[1].substring(0, 1);
        } else {
            initials = fullName.substring(0, 2).toUpperCase();
        }
    }
    String context = request.getContextPath();
    String currentURI = request.getRequestURI();
    
    String sysTheme = (String) session.getAttribute("userThemeMode");
    if (sysTheme == null) {
        sysTheme = (String) application.getAttribute("sys_themeMode");
    }
    if ("dark".equals(sysTheme)) {
%>
    <link rel="stylesheet" href="<%= context %>/css/superadmin-dark.css">
<%
    }
    
    // Check active pages
    boolean isDashboard = currentURI.endsWith("dashboard.jsp") || currentURI.endsWith("/dashboard") || currentURI.endsWith("/gov-dashboard") || currentURI.endsWith("gov-dashboard.jsp");

    boolean isMyGunaso = currentURI.endsWith("my-gunaso") || currentURI.endsWith("my-gunaso.jsp");
    boolean isProfile = currentURI.endsWith("profile.jsp");
    boolean isManageUsers = currentURI.endsWith("manage-users.jsp");
    boolean isDepts = currentURI.endsWith("departments.jsp");
    boolean isSettings = currentURI.endsWith("system-settings.jsp");
    boolean isManageGunaso = currentURI.endsWith("manage-gunaso.jsp") || currentURI.endsWith("manage-gunaso");
    boolean isReports = currentURI.endsWith("reports.jsp");
    boolean isVerify = currentURI.endsWith("verify-requests.jsp");
    boolean isSarkarUpdates = currentURI.contains("sarkar-updates");
%>
<div class="sidebar">
    <div class="sidebar-header">
        <a href="<%= context %>/index.jsp" class="sidebar-brand">
            <img src="https://upload.wikimedia.org/wikipedia/commons/2/23/Emblem_of_Nepal.svg" alt="Emblem of Nepal">
            <div class="sidebar-brand-text">
                <h2>Gunaso</h2>
                <span>Portal</span>
            </div>
        </a>
    </div>
    
    <ul class="sidebar-menu">
        <% if ("CITIZEN".equals(role)) { %>
            <li><a href="<%= context %>/dashboard" class="<%= isDashboard ? "active" : "" %>"><i class="fa-solid fa-house"></i> Dashboard</a></li>
            <li><a href="<%= context %>/user/sarkar-updates" class="<%= isSarkarUpdates ? "active" : "" %>"><i class="fa-solid fa-bullhorn"></i> Sarkar Updates</a></li>
            <li><a href="<%= context %>/user/my-gunaso" class="<%= isMyGunaso ? "active" : "" %>"><i class="fa-solid fa-list-check"></i> Mero Gunaso</a></li>

            <li><a href="<%= context %>/user/profile.jsp" class="<%= isProfile ? "active" : "" %>"><i class="fa-solid fa-user-gear"></i> Settings</a></li>
        <% } else if ("SUPER_ADMIN".equals(role)) { %>
            <li><a href="<%= context %>/dashboard" class="<%= isDashboard ? "active" : "" %>"><i class="fa-solid fa-house"></i> Dashboard</a></li>
            <li><a href="<%= context %>/user/sarkar-updates" class="<%= isSarkarUpdates ? "active" : "" %>"><i class="fa-solid fa-bullhorn"></i> Sarkar Updates</a></li>
            <li><a href="<%= context %>/superadmin/manage-users.jsp" class="<%= isManageUsers ? "active" : "" %>"><i class="fa-solid fa-users"></i> Manage Users</a></li>
            <li><a href="<%= context %>/superadmin/departments.jsp" class="<%= isDepts ? "active" : "" %>"><i class="fa-solid fa-building"></i> Departments</a></li>
            <li><a href="<%= context %>/superadmin/manage-gunaso" class="<%= isManageGunaso ? "active" : "" %>"><i class="fa-solid fa-folder-open"></i> All Grievances</a></li>
            <li><a href="<%= context %>/admin/verify-requests.jsp" class="<%= isVerify ? "active" : "" %>"><i class="fa-solid fa-id-card-clip"></i> Verification Reqs</a></li>
            <li><a href="<%= context %>/superadmin/system-settings.jsp" class="<%= isSettings ? "active" : "" %>"><i class="fa-solid fa-gear"></i> Settings</a></li>
        <% } else { %>
            <li><a href="<%= context %>/gov-dashboard" class="<%= isDashboard ? "active" : "" %>"><i class="fa-solid fa-house"></i> Dashboard</a></li>
            <li><a href="<%= context %>/user/sarkar-updates" class="<%= isSarkarUpdates ? "active" : "" %>"><i class="fa-solid fa-bullhorn"></i> Sarkar Updates</a></li>
            <li><a href="<%= context %>/admin/manage-gunaso.jsp" class="<%= isManageGunaso ? "active" : "" %>"><i class="fa-solid fa-list-check"></i> View Gunaso</a></li>
            <li><a href="<%= context %>/user/profile.jsp" class="<%= isProfile ? "active" : "" %>"><i class="fa-solid fa-user-gear"></i> Settings</a></li>
        <% } %>
    </ul>

    <div class="sidebar-profile">
        <% if(user != null && user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
            <div class="profile-avatar" style="background-image: url('<%= context %>/<%= user.getAvatar() %>'); background-size: cover; background-position: center; color: transparent;"></div>
        <% } else { %>
            <div class="profile-avatar"><%= initials.toUpperCase() %></div>
        <% } %>
        <div class="profile-info">
            <h4><%= fullName %></h4>
            <span><%= role %></span>
        </div>
        <button class="logout-btn" title="Logout" onclick="window.location.href='<%= context %>/auth/logout'"><i class="fa-solid fa-right-from-bracket"></i></button>
    </div>
</div>
