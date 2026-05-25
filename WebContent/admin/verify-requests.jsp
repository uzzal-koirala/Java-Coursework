<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.User, dao.UserDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verification Requests - Gunaso Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <script src="<%= request.getContextPath() %>/js/script.js" defer></script>
</head>
<body>
    <div class="dashboard-wrapper">
        <jsp:include page="/components/sidebar.jsp" />
        
        <main class="main-content">
            <div class="top-bar">
                <div class="page-title">
                    <h1>Verification Requests</h1>
                    <p>Review and approve citizen identity documents</p>
                </div>
            </div>
            
            <div class="dashboard-body">
                <div class="section-header">
                    <h2>Pending Verifications</h2>
                </div>
                
                <% 
                    String error = (String) session.getAttribute("error");
                    if (error != null) {
                %>
                    <div class="message message-error" style="background: rgba(239, 68, 68, 0.1); color: var(--secondary); padding: 15px; border-radius: 8px; margin-bottom: 20px;"><%= error %></div>
                <% session.removeAttribute("error"); } %>
                
                <% 
                    String success = (String) session.getAttribute("success");
                    if (success != null) {
                %>
                    <div class="message message-success" style="background: rgba(16, 185, 129, 0.1); color: #059669; padding: 15px; border-radius: 8px; margin-bottom: 20px;"><%= success %></div>
                <% session.removeAttribute("success"); } %>

                <div class="data-table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Citizen Name</th>
                                <th>Citizenship No</th>
                                <th>Documents</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                UserDAO dao = new UserDAO();
                                List<User> pendingUsers = dao.getPendingVerificationUsers();
                                
                                if (pendingUsers != null && !pendingUsers.isEmpty()) {
                                    for (User u : pendingUsers) {
                            %>
                                <tr>
                                    <td class="title-col">
                                        <div style="display: flex; align-items: center; gap: 10px;">
                                            <% if(u.getAvatar() != null && !u.getAvatar().isEmpty()) { %>
                                                <div style="width: 35px; height: 35px; border-radius: 50%; background-image: url('<%= request.getContextPath() %>/<%= u.getAvatar() %>'); background-size: cover; background-position: center;"></div>
                                            <% } else { %>
                                                <div style="width: 35px; height: 35px; border-radius: 50%; background: var(--primary-light); color: white; display: flex; align-items: center; justify-content: center; font-weight: bold;">
                                                    <%= u.getFullName().substring(0, 1).toUpperCase() %>
                                                </div>
                                            <% } %>
                                            <div>
                                                <div><%= u.getFullName() %></div>
                                                <div style="font-size: 0.8rem; color: var(--text-light); font-weight: 400;"><%= u.getEmail() %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span style="font-family: monospace; font-weight: 600;"><%= u.getCitizenshipNo() %></span></td>
                                    <td>
                                        <% if(u.getCitizenshipPhoto() != null) { %>
                                            <a href="<%= request.getContextPath() %>/<%= u.getCitizenshipPhoto() %>" target="_blank" style="color: var(--primary-light); text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 5px;">
                                                <i class="fa-regular fa-image"></i> View Document
                                            </a>
                                        <% } else { %>
                                            <span style="color: var(--secondary);">No Document</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <span class="badge badge-pending">Pending</span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 10px;">
                                            <form action="<%= request.getContextPath() %>/admin/verify" method="POST" style="margin: 0;">
                                                <input type="hidden" name="userId" value="<%= u.getId() %>">
                                                <input type="hidden" name="action" value="approve">
                                                <button type="submit" class="btn-view" style="background: rgba(16, 185, 129, 0.1); color: #059669; cursor: pointer; border: none;">
                                                    <i class="fa-solid fa-check"></i> Approve
                                                </button>
                                            </form>
                                            <form action="<%= request.getContextPath() %>/admin/verify" method="POST" style="margin: 0;">
                                                <input type="hidden" name="userId" value="<%= u.getId() %>">
                                                <input type="hidden" name="action" value="reject">
                                                <button type="submit" class="btn-view" style="background: rgba(239, 68, 68, 0.1); color: var(--secondary); cursor: pointer; border: none;">
                                                    <i class="fa-solid fa-xmark"></i> Reject
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="5" style="text-align: center; padding: 40px; color: var(--text-light);">
                                        <i class="fa-solid fa-check-double" style="font-size: 3rem; opacity: 0.2; margin-bottom: 15px; display: block;"></i>
                                        All caught up! No pending verification requests.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
// Done by Manjila