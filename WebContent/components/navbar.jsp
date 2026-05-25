<%@ page import="model.User" %>
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
%>
<div class="top-bar">
    <div class="breadcrumb">
        <h2><%= pageTitle %></h2>
    </div>
    <div class="user-info">
        <span>Welcome, <%= currentUser.getFullName() %> (<%= currentUser.getRoleName() %>)</span>
        <a href="<%= request.getContextPath() %>/auth/logout" class="btn" style="padding: 8px 15px; font-size: 0.8rem; width: auto;">Logout</a>
    </div>
</div>
// Done by Manjila