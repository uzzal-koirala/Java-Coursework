<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Gunaso" %>
<%@ page import="model.User" %>
<%@ page import="model.SarkarUpdate" %>
<%@ page import="model.UpdateComment" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    String displayName = (sessionUser != null) ? sessionUser.getFullName() : "Citizen";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Citizen Dashboard - Gunaso Portal</title>
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Main Dashboard CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/feed.css">
    <script src="<%= request.getContextPath() %>/js/script.js" defer></script>
</head>
<body>
    <div class="dashboard-wrapper">
        <!-- Modern Sidebar -->
        <jsp:include page="/components/sidebar.jsp" />
        
        <!-- Main Content Area -->
        <main class="main-content">
            
            <!-- Top Navigation Bar -->
            <div class="top-bar">
                <div class="page-title">
                    <h1>Overview</h1>
                    <p>Track and manage your civic grievances</p>
                </div>
                <div class="top-actions">
                    <div class="search-box">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" placeholder="Search tracking ID...">
                    </div>
                    <div class="notification-bell">
                        <i class="fa-regular fa-bell"></i>
                        <span class="notification-dot"></span>
                    </div>
                </div>
            </div>

            <!-- Dashboard Body -->
            <div class="dashboard-body">
                
                <!-- Welcome Hero -->
                <div class="dashboard-hero">
                    <div class="hero-text">
                        <h2>Welcome back, <%= displayName %>!</h2>
                        <p>Your voice drives better governance. Track your existing grievances or file a new one instantly using our secure portal.</p>
                    </div>

                </div>

                <% 
                    List<Gunaso> gunasos = (List<Gunaso>) request.getAttribute("gunasos");
                    List<SarkarUpdate> feed = (List<SarkarUpdate>) request.getAttribute("feed");

                    int totalG = gunasos != null ? gunasos.size() : 0;
                    int pendingG = 0;
                    int progressG = 0;
                    int resolvedG = 0;
                    if (gunasos != null) {
                        for (Gunaso g : gunasos) {
                            String s = g.getStatus();
                            if (s != null) {
                                if ("Pending".equalsIgnoreCase(s) || "In Review".equalsIgnoreCase(s)) {
                                    pendingG++;
                                } else if ("In Progress".equalsIgnoreCase(s)) {
                                    progressG++;
                                } else if ("Solved".equalsIgnoreCase(s) || "Resolved".equalsIgnoreCase(s)) {
                                    resolvedG++;
                                }
                            }
                        }
                    }
                %>

                <!-- Stats Grid -->
                <div class="stats-grid">
                    <div class="stat-card stat-total">
                        <div class="stat-info">
                            <h3>Total Grievances</h3>
                            <div class="value"><%= totalG %></div>
                        </div>
                        <div class="stat-icon"><i class="fa-solid fa-folder-open"></i></div>
                    </div>
                    
                    <div class="stat-card stat-pending">
                        <div class="stat-info">
                            <h3>Pending Review</h3>
                            <div class="value"><%= pendingG %></div>
                        </div>
                        <div class="stat-icon"><i class="fa-solid fa-clock-rotate-left"></i></div>
                    </div>
                    
                    <div class="stat-card stat-progress">
                        <div class="stat-info">
                            <h3>In Progress</h3>
                            <div class="value"><%= progressG %></div>
                        </div>
                        <div class="stat-icon"><i class="fa-solid fa-spinner"></i></div>
                    </div>

                    <div class="stat-card stat-resolved">
                        <div class="stat-info">
                            <h3>Resolved</h3>
                            <div class="value"><%= resolvedG %></div>
                        </div>
                        <div class="stat-icon"><i class="fa-solid fa-circle-check"></i></div>
                    </div>
                </div>

                <!-- Two Column Dashboard Grid -->
                <div style="display: grid; grid-template-columns: 1.6fr 1fr; gap: 30px; margin-top: 35px; align-items: start;">
                    
                    <!-- Left Column: Grievances Table -->
                    <div>
                        <div class="section-header" style="margin-top: 0;">
                            <h2>Recent Grievances</h2>
                            <a href="my-gunaso" class="view-all-link">View All <i class="fa-solid fa-arrow-right"></i></a>
                        </div>

                        <div class="data-table-container">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Tracking ID</th>
                                        <th>Issue Title</th>
                                        <th>Assigned Dept</th>
                                        <th>Current Status</th>
                                        <th>Filed Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        if (gunasos != null && !gunasos.isEmpty()) {
                                            for (Gunaso g : gunasos) {
                                                String badgeClass = "badge-pending";
                                                String status = g.getStatus().toLowerCase();
                                                if (status.contains("review") || status.contains("progress")) badgeClass = "badge-review";
                                                if (status.contains("solve") || status.contains("resolv")) badgeClass = "badge-resolved";
                                                if (status.contains("reject")) badgeClass = "badge-rejected";
                                    %>
                                        <tr>
                                            <td class="id-col">#<%= g.getId() %></td>
                                            <td class="title-col"><%= g.getTitle() %></td>
                                            <td><%= g.getDeptName() %></td>
                                            <td>
                                                <span class="badge <%= badgeClass %>"><%= g.getStatus() %></span>
                                            </td>
                                            <td><%= g.getCreatedAt() %></td>
                                            <td>
                                                <a href="<%= request.getContextPath() %>/gunaso/view?id=<%= g.getId() %>" class="btn-view">
                                                    <i class="fa-regular fa-eye"></i> View
                                                </a>
                                            </td>
                                        </tr>
                                    <% 
                                            }
                                        } else {
                                    %>
                                        <tr>
                                            <td colspan="6" style="text-align: center; padding: 40px; color: var(--text-light);">
                                                <i class="fa-solid fa-inbox" style="font-size: 3rem; opacity: 0.2; margin-bottom: 15px; display: block;"></i>
                                                No grievances submitted yet. 
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Right Column: Sarkar Updates (Facebook Post Feed) -->
                    <div>
                        <div class="section-header" style="margin-top: 0;">
                            <h2>Sarkar Updates</h2>
                            <a href="<%= request.getContextPath() %>/user/sarkar-updates" class="view-all-link">View Feed <i class="fa-solid fa-arrow-right"></i></a>
                        </div>
                        
                        <div class="feed-container" style="max-width: 100%; padding: 0;">
                            <%
                                if (feed != null && !feed.isEmpty()) {
                                    int count = 0;
                                    for (SarkarUpdate update : feed) {
                                        if (count >= 2) break; // Only show 2 latest posts on user dashboard
                                        count++;
                                        String authorAvatar = (update.getUserAvatar() != null) ? request.getContextPath() + "/" + update.getUserAvatar() : "https://ui-avatars.com/api/?name=" + update.getUserFullName() + "&background=random";
                            %>
                            <div class="post-card" style="margin-bottom: 20px; border-radius: 16px;">
                                <div class="post-header" style="padding: 15px 15px 10px;">
                                    <img src="<%= authorAvatar %>" alt="Author" class="create-post-avatar" style="width: 38px; height: 38px;">
                                    <div class="post-author-info">
                                        <span class="post-author-name" style="font-size: 0.95rem;"><%= update.getUserFullName() %></span>
                                        <span class="post-author-meta" style="font-size: 0.75rem;">
                                            <span class="post-badge" style="font-size: 0.65rem; padding: 1px 6px;"><%= update.getUserRoleName().replace("_", " ") %></span>
                                            • <%= new java.text.SimpleDateFormat("MMM dd").format(update.getCreatedAt()) %>
                                        </span>
                                    </div>
                                </div>

                                <div class="post-content" style="padding: 0 15px 10px; font-size: 0.92rem; line-height: 1.5;">
                                    <%= update.getContent() %>
                                </div>

                                <% if (update.getPhotoUrl() != null && !update.getPhotoUrl().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/<%= update.getPhotoUrl() %>" alt="Post Photo" class="post-photo" style="width: calc(100% - 30px); margin: 0 15px 10px; border-radius: 10px; max-height: 250px;">
                                <% } %>

                                <div class="post-stats" style="padding: 10px 15px; font-size: 0.8rem;">
                                    <span><i class="fa-solid fa-thumbs-up"></i> <%= update.getLikeCount() %> Likes</span>
                                    <span><%= update.getCommentCount() %> Comments</span>
                                </div>

                                <div class="post-actions" style="padding: 5px 15px; gap: 5px;">
                                    <form action="<%= request.getContextPath() %>/user/sarkar-updates/action" method="POST" style="flex:1; margin:0;">
                                        <input type="hidden" name="action" value="like">
                                        <input type="hidden" name="updateId" value="<%= update.getId() %>">
                                        <input type="hidden" name="redirect" value="dashboard">
                                        <button type="submit" class="action-btn <%= update.isLikedByCurrentUser() ? "liked" : "" %>" style="padding: 8px; font-size: 0.85rem; border-radius: 8px;">
                                            <i class="fa-solid fa-thumbs-up" style="font-size: 1rem;"></i> <%= update.isLikedByCurrentUser() ? "Liked" : "Like" %>
                                        </button>
                                    </form>
                                    <button class="action-btn" onclick="location.href='<%= request.getContextPath() %>/user/sarkar-updates'" style="flex:1; padding: 8px; font-size: 0.85rem; border-radius: 8px;">
                                        <i class="fa-solid fa-comment" style="font-size: 1rem;"></i> Comment
                                    </button>
                                </div>
                            </div>
                            <% 
                                    }
                                } else { 
                            %>
                            <div class="empty-state" style="padding: 30px; text-align: center; background: var(--glass-bg); border: 1px solid var(--glass-border); border-radius: 16px;">
                                <i class="fa-solid fa-bullhorn" style="font-size: 2rem; opacity: 0.2; margin-bottom: 10px; display: block;"></i>
                                <p style="color: var(--text-light); font-size: 0.9rem; margin: 0;">No government updates available.</p>
                            </div>
                            <% } %>
                        </div>
                    </div>

                </div>

            </div>
            
        </main>
    </div>
</body>
</html>
