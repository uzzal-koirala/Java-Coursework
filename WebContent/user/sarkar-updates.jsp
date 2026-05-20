<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.SarkarUpdate, model.UpdateComment, model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sarkar Updates - Gunaso Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/feed.css">
    <script src="<%= request.getContextPath() %>/js/script.js" defer></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
</head>
<body>
    <div class="dashboard-wrapper">
        <jsp:include page="/components/sidebar.jsp" />
        
        <main class="main-content">
                    <%
                        User user = (User) session.getAttribute("user");
                        String role = (user != null) ? user.getRoleName() : "CITIZEN";
                        String avatar = (user != null && user.getAvatar() != null) ? request.getContextPath() + "/" + user.getAvatar() : "https://ui-avatars.com/api/?name=" + (user != null ? user.getFullName() : "User") + "&background=random";
                    %>
            <div class="top-bar">
                <div class="page-title">
                    <h1 style="display:none;">Sarkar Updates</h1>
                    <p style="display:none;"></p>
                </div>
                <div class="top-actions">
                    <div class="search-box">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" placeholder="Search updates...">
                    </div>
                    <div class="notification-bell">
                        <i class="fa-regular fa-bell"></i>
                        <span class="notification-dot"></span>
                    </div>
                </div>
            </div>

            <div class="dashboard-body">
                <div class="page-header">
                    <h1>Sarkar Updates</h1>
                    <p>Stay informed with the latest updates from government authorities.</p>
                </div>

                <div class="feed-container">
                    
                    <%-- Show Create Post Box only for Authorities --%>
                    <% if (!"CITIZEN".equals(role)) { %>
                    <div class="create-post-box">
                        <form action="<%= request.getContextPath() %>/user/sarkar-updates/action" method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="post">
                            <div class="create-post-header">
                                <img src="<%= avatar %>" alt="Profile" class="create-post-avatar">
                                <textarea name="content" class="create-post-input" placeholder="What's the latest update, <%= user.getFullName() %>?" rows="2" required></textarea>
                            </div>
                            <div class="create-post-actions">
                                <label class="photo-upload-label">
                                    <i class="fa-solid fa-image"></i> Add Photo
                                    <input type="file" name="photo" accept="image/*">
                                </label>
                                <button type="submit" class="post-btn"><i class="fa-solid fa-paper-plane"></i> Post Update</button>
                            </div>
                        </form>
                    </div>
                    <% } %>

                    <%-- Feed List --%>
                    <%
                        List<SarkarUpdate> feed = (List<SarkarUpdate>) request.getAttribute("feed");
                        if (feed != null && !feed.isEmpty()) {
                            for (SarkarUpdate update : feed) {
                                String authorAvatar = (update.getUserAvatar() != null) ? request.getContextPath() + "/" + update.getUserAvatar() : "https://ui-avatars.com/api/?name=" + update.getUserFullName() + "&background=random";
                    %>
                    <div class="post-card">
                        <div class="post-header">
                            <img src="<%= authorAvatar %>" alt="Author" class="create-post-avatar">
                            <div class="post-author-info">
                                <span class="post-author-name"><%= update.getUserFullName() %></span>
                                <span class="post-author-meta">
                                    <span class="post-badge"><%= update.getUserRoleName().replace("_", " ") %></span>
                                    • <%= new java.text.SimpleDateFormat("MMM dd, yyyy h:mm a").format(update.getCreatedAt()) %>
                                </span>
                            </div>
                        </div>

                        <div class="post-content">
                            <%= update.getContent() %>
                        </div>

                        <% if (update.getPhotoUrl() != null && !update.getPhotoUrl().isEmpty()) { %>
                        <img src="<%= request.getContextPath() %>/<%= update.getPhotoUrl() %>" alt="Post Photo" class="post-photo">
                        <% } %>

                        <div class="post-stats">
                            <span><i class="fa-solid fa-thumbs-up"></i> <%= update.getLikeCount() %> Likes</span>
                            <span><%= update.getCommentCount() %> Comments</span>
                        </div>

                        <div class="post-actions">
                            <form action="<%= request.getContextPath() %>/user/sarkar-updates/action" method="POST" style="flex:1;">
                                <input type="hidden" name="action" value="like">
                                <input type="hidden" name="updateId" value="<%= update.getId() %>">
                                <button type="submit" class="action-btn <%= update.isLikedByCurrentUser() ? "liked" : "" %>">
                                    <i class="fa-solid fa-thumbs-up"></i> <%= update.isLikedByCurrentUser() ? "Liked" : "Like" %>
                                </button>
                            </form>
                            <button class="action-btn" onclick="document.getElementById('comment-input-<%= update.getId() %>').focus()">
                                <i class="fa-solid fa-comment"></i> Comment
                            </button>
                        </div>

                        <div class="post-comments">
                            <div class="comment-list">
                                <% for (UpdateComment comment : update.getComments()) { 
                                    String cAvatar = (comment.getUserAvatar() != null) ? request.getContextPath() + "/" + comment.getUserAvatar() : "https://ui-avatars.com/api/?name=" + comment.getUserFullName() + "&background=random";
                                %>
                                <div class="comment-item">
                                    <img src="<%= cAvatar %>" alt="User" class="comment-avatar">
                                    <div class="comment-content-wrapper">
                                        <div class="comment-author">
                                            <%= comment.getUserFullName() %> 
                                            <% if (!"CITIZEN".equals(comment.getUserRoleName())) { %>
                                                <i class="fa-solid fa-circle-check" style="color: #4facfe; font-size: 0.8rem;" title="Authority"></i>
                                            <% } %>
                                        </div>
                                        <div class="comment-text"><%= comment.getComment() %></div>
                                    </div>
                                </div>
                                <% } %>
                            </div>

                            <form action="<%= request.getContextPath() %>/user/sarkar-updates/action" method="POST" class="comment-input-area">
                                <input type="hidden" name="action" value="comment">
                                <input type="hidden" name="updateId" value="<%= update.getId() %>">
                                <img src="<%= avatar %>" alt="Profile" class="comment-avatar">
                                <input type="text" name="comment" id="comment-input-<%= update.getId() %>" class="comment-input" placeholder="Write a comment..." required>
                                <button type="submit" class="comment-submit-btn"><i class="fa-solid fa-paper-plane"></i></button>
                            </form>
                        </div>
                    </div>
                    <% 
                            }
                        } else { 
                    %>
                        <div class="empty-state">
                            <i class="fa-solid fa-bullhorn empty-icon"></i>
                            <h3>No Updates Yet</h3>
                            <p>There are no updates from the government authorities at this time.</p>
                        </div>
                    <% } %>

                </div>
            </div>
        </main>
    </div>
    
    <%-- Include toast notification script logic --%>
    <% 
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");
        if (success != null || error != null) {
    %>
        <script>
            document.addEventListener('DOMContentLoaded', () => {
                <% if (success != null) { %>
                    showToast('Success', '<%= success %>', 'success');
                    <% session.removeAttribute("success"); %>
                <% } %>
                <% if (error != null) { %>
                    showToast('Error', '<%= error %>', 'error');
                    <% session.removeAttribute("error"); %>
                <% } %>
            });
        </script>
    <% } %>
</body>
</html>
