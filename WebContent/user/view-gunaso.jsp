<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Gunaso, model.Reply, model.User" %>
<% boolean isPopup = "true".equals(request.getParameter("popup")); %>
<%@ page import="java.util.List, model.Gunaso, model.Reply, model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Gunaso - Gunaso Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <style>
        .detail-card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            color: #333;
        }
        .detail-header {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        .reply-item {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 15px;
            border-left: 4px solid #3498db;
        }
        .reply-meta {
            font-size: 0.8rem;
            color: #7f8c8d;
            margin-bottom: 5px;
        }
        .reply-form {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
    </style>
</head>
<body>
    <div class="<%= isPopup ? "" : "dashboard-wrapper" %>">
        <% if (!isPopup) { %>
            <jsp:include page="/components/sidebar.jsp" />
        <% } %>
        
        <div class="<%= isPopup ? "" : "main-content" %>" style="<%= isPopup ? "padding: 20px;" : "" %>">
            <% if (!isPopup) { %>
                <jsp:include page="/components/navbar.jsp" />
            <% } %>
            
            <div style="max-width: 900px; margin: 0 auto;">
                <% 
                    Gunaso g = (Gunaso) request.getAttribute("gunaso");
                    User currentUser = (User) session.getAttribute("user");
                %>
                
                <div class="detail-card">
                    <div class="detail-header">
                        <div>
                            <h2 style="margin-bottom: 5px;"><%= g.getTitle() %></h2>
                            <span class="badge badge-<%= g.getStatus().toLowerCase().replace(" ", "-") %>"><%= g.getStatus() %></span>
                        </div>
                        <div style="text-align: right;">
                            <p style="font-size: 0.9rem; color: #7f8c8d;">Submitted by: <strong><%= g.getUserName() %></strong></p>
                            <p style="font-size: 0.8rem; color: #95a5a6;"><%= g.getCreatedAt() %></p>
                        </div>
                    </div>
                    
                    <p style="font-weight: 600; margin-bottom: 10px;">Department: <%= g.getDeptName() %></p>
                    <div style="line-height: 1.6; margin-bottom: 20px;">
                        <%= g.getDescription() %>
                    </div>
                    
                    <% if (g.getAttachment() != null && !g.getAttachment().isEmpty()) { %>
                        <div style="margin-top: 20px;">
                            <strong>Attachment:</strong> 
                            <a href="<%= request.getContextPath() %>/uploads/<%= g.getAttachment() %>" target="_blank" style="color: #3498db;">View File</a>
                        </div>
                    <% } %>
                </div>

                <div class="detail-card">
                    <h3>Discussion / Replies</h3>
                    <div style="margin-top: 20px;">
                        <% 
                            List<Reply> replies = (List<Reply>) request.getAttribute("replies");
                            if (replies != null && !replies.isEmpty()) {
                                for (Reply r : replies) {
                        %>
                            <div class="reply-item">
                                <div class="reply-meta">
                                    <strong><%= r.getUserName() %></strong> (<%= r.getRoleName() %>) - <%= r.getCreatedAt() %>
                                </div>
                                <div class="reply-content">
                                    <%= r.getMessage() %>
                                </div>
                            </div>
                        <% 
                                }
                            } else {
                        %>
                            <p style="color: #7f8c8d; text-align: center;">No replies yet.</p>
                        <% } %>
                    </div>

                    <div class="reply-form">
                        <h4>Add a Reply</h4>
                        <form action="<%= request.getContextPath() %>/gunaso/reply" method="POST">
                            <input type="hidden" name="gunasoId" value="<%= g.getId() %>">
                            <textarea name="message" rows="4" placeholder="Write your reply here..." required style="width: 100%; padding: 12px; border-radius: 10px; border: 1px solid #ddd; margin: 15px 0; outline: none;"></textarea>
                            <button type="submit" class="btn" style="width: auto; padding: 10px 25px;">Post Reply</button>
                        </form>
                    </div>
                </div>
            </div>
            
            <% if (!isPopup) { %>
                <jsp:include page="/components/footer.jsp" />
            <% } %>
        </div>
    </div>
    
    <% if (isPopup) { %>
    <script>
        // If inside an iframe and a form is submitted (like reply), reload the parent page on success
        // We'll add a target to the form to submit to itself, and if success is true, we could notify parent.
        // For simplicity, let's just let it reload the iframe.
    </script>
    <style>
        body { background: #f8fafc; }
        .detail-card { box-shadow: none; border: 1px solid #e2e8f0; }
    </style>
    <% } %>
</body>
</html>
