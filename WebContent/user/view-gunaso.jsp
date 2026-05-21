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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { font-family: 'Inter', sans-serif; color: #050505; background: #f0f2f5; }
        
        /* Facebook Post Style */
        .fb-post { background: #fff; border-radius: 8px; box-shadow: 0 1px 2px rgba(0,0,0,0.2); margin-bottom: 20px; overflow: hidden; }
        .fb-header { display: flex; align-items: center; padding: 12px 16px; gap: 10px; }
        .fb-avatar { width: 40px; height: 40px; background: linear-gradient(135deg, #1877f2, #1b5ccb); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 1.1rem; flex-shrink: 0; }
        .fb-author { flex: 1; }
        .fb-author h3 { margin: 0; font-size: 0.95rem; color: #050505; font-weight: 600; }
        .fb-meta { margin: 2px 0 0; font-size: 0.8rem; color: #65676B; display: flex; align-items: center; gap: 4px; }
        .fb-content { padding: 4px 16px 12px; }
        .fb-title { font-size: 1rem; font-weight: 600; color: #050505; margin: 0 0 6px 0; }
        .fb-desc { font-size: 0.95rem; color: #050505; line-height: 1.5; white-space: pre-wrap; }
        .fb-img-container { width: 100%; max-height: 300px; overflow: hidden; display: flex; align-items: center; justify-content: center; background: transparent; margin-bottom: 12px; }
        .fb-img-container img { width: auto; max-width: 100%; max-height: 300px; object-fit: contain; border-radius: 8px; border: 1px solid #ebedf0; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .fb-footer { padding: 10px 16px; border-top: 1px solid #ebedf0; display: flex; justify-content: space-between; align-items: center; color: #65676B; font-weight: 600; font-size: 0.9rem; }
        
        /* Chat UI Style */
        .chat-card { background: #fff; border-radius: 8px; box-shadow: 0 1px 2px rgba(0,0,0,0.2); padding: 16px; margin-bottom: 30px; }
        .chat-container { display: flex; flex-direction: column; gap: 16px; padding: 10px 0; }
        .chat-row { display: flex; width: 100%; }
        .chat-row.incoming { justify-content: flex-start; }
        .chat-row.outgoing { justify-content: flex-end; }
        .chat-bubble-wrapper { max-width: 75%; display: flex; flex-direction: column; }
        .chat-row.incoming .chat-bubble-wrapper { align-items: flex-start; }
        .chat-row.outgoing .chat-bubble-wrapper { align-items: flex-end; }
        .chat-bubble { padding: 10px 14px; border-radius: 18px; font-size: 0.95rem; line-height: 1.4; position: relative; word-break: break-word; }
        .chat-row.incoming .chat-bubble { background: #e4e6eb; color: #050505; border-bottom-left-radius: 4px; }
        .chat-row.outgoing .chat-bubble { background: #0084ff; color: white; border-bottom-right-radius: 4px; }
        .chat-sender { font-size: 0.75rem; color: #65676B; margin-bottom: 4px; padding: 0 4px; }
        .chat-time { font-size: 0.7rem; color: #8c939d; margin-top: 4px; padding: 0 4px; }
        
        .badge { padding: 4px 10px; border-radius: 100px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase; }

        .reply-form { margin-top: 20px; border-top: 1px solid #ebedf0; padding-top: 16px; }
        .reply-textarea { width: 100%; padding: 12px 16px; border-radius: 20px; border: 1px solid #ccd0d5; background: #f0f2f5; outline: none; font-family: 'Inter', sans-serif; resize: none; margin-bottom: 10px; box-sizing: border-box; }
        .reply-textarea:focus { border-color: #0084ff; background: #fff; }
        .btn-post { background: #0084ff; color: white; padding: 8px 20px; border-radius: 20px; border: none; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .btn-post:hover { background: #0073e6; }
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
                    String authorInitial = g.getUserName() != null && !g.getUserName().isEmpty() ? g.getUserName().substring(0, 1).toUpperCase() : "U";
                %>
                
                <div class="fb-post">
                    <div class="fb-header">
                        <div class="fb-avatar"><%= authorInitial %></div>
                        <div class="fb-author">
                            <h3><%= g.getUserName() %></h3>
                            <div class="fb-meta">
                                <span><%= g.getCreatedAt() %></span> • 
                                <i class="fa-solid fa-earth-americas"></i>
                            </div>
                        </div>
                        <div>
                            <span class="badge badge-<%= g.getStatus().toLowerCase().replace(" ", "-") %>"><%= g.getStatus() %></span>
                        </div>
                    </div>
                    
                    <div class="fb-content">
                        <h4 class="fb-title"><%= g.getTitle() %></h4>
                        <div class="fb-desc"><%= g.getDescription() %></div>
                    </div>
                    
                    <% if (g.getAttachment() != null && !g.getAttachment().isEmpty()) { 
                        String ext = g.getAttachment().substring(g.getAttachment().lastIndexOf('.') + 1).toLowerCase();
                        boolean isImg = ext.equals("jpg") || ext.equals("jpeg") || ext.equals("png") || ext.equals("gif");
                        if (isImg) {
                    %>
                        <div class="fb-img-container">
                            <img src="<%= request.getContextPath() %>/uploads/<%= g.getAttachment() %>" alt="Attachment">
                        </div>
                    <% } else { %>
                        <div style="padding: 0 16px 16px;">
                            <a href="<%= request.getContextPath() %>/uploads/<%= g.getAttachment() %>" target="_blank" style="display: inline-block; padding: 8px 16px; background: #f0f2f5; border-radius: 6px; color: #1877f2; text-decoration: none; font-weight: 600;"><i class="fa-solid fa-file-arrow-down"></i> Download Attached Document</a>
                        </div>
                    <%  } 
                       } 
                    %>
                    
                    <div class="fb-footer">
                        <div><i class="fa-solid fa-building"></i> Dept: <%= g.getDeptName() %></div>
                        <div><i class="fa-solid fa-comment"></i> Discussion below</div>
                    </div>
                </div>

                <div class="chat-card">
                    <div class="chat-container">
                        <% 
                            List<Reply> replies = (List<Reply>) request.getAttribute("replies");
                            if (replies != null && !replies.isEmpty()) {
                                for (Reply r : replies) {
                                    boolean isMe = (r.getUserId() == currentUser.getId());
                                    String rowClass = isMe ? "outgoing" : "incoming";
                        %>
                            <div class="chat-row <%= rowClass %>">
                                <div class="chat-bubble-wrapper">
                                    <div class="chat-sender">
                                        <%= isMe ? "You" : r.getUserName() + " • " + r.getRoleName().replace("_", " ") %>
                                    </div>
                                    <div class="chat-bubble">
                                        <%= r.getMessage() %>
                                    </div>
                                    <div class="chat-time"><%= r.getCreatedAt() %></div>
                                </div>
                            </div>
                        <% 
                                }
                            } else {
                        %>
                            <div style="text-align: center; padding: 30px 10px; color: #65676B;">
                                <i class="fa-regular fa-comments" style="font-size: 2rem; color: #ccd0d5; margin-bottom: 8px;"></i>
                                <p style="margin: 0;">No messages yet. Send a message to start the conversation.</p>
                            </div>
                        <% } %>
                    </div>

                    <div class="reply-form">
                        <form action="<%= request.getContextPath() %>/gunaso/reply" method="POST" style="display: flex; gap: 10px; align-items: flex-start;">
                            <input type="hidden" name="gunasoId" value="<%= g.getId() %>">
                            <% if (isPopup) { %>
                                <input type="hidden" name="popup" value="true">
                            <% } %>
                            <textarea name="message" class="reply-textarea" rows="2" placeholder="Write a message..." required></textarea>
                            <button type="submit" class="btn-post"><i class="fa-solid fa-paper-plane"></i></button>
                        </form>
                    </div>
                </div>
            </div>
            
            <% if (!isPopup) { %>
<% } %>
        </div>
    </div>
    
    <% if (isPopup) { %>
    <script>
        // Adjust parent iframe height if needed
        window.onload = function() {
            if (window.parent && window.parent.document.getElementById('viewIframe')) {
                // optional auto-resize logic
            }
        };
    </script>
    <style>
        body { background: transparent !important; margin: 0; padding: 0; overflow-x: hidden; }
        .fb-post, .chat-card { box-shadow: none; border: none; margin-bottom: 10px; background: transparent; }
        .fb-post { border-bottom: 1px solid #ddd; border-radius: 0; margin-bottom: 15px; }
        .main-content { padding: 0 !important; }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-thumb { background: #bcc0c4; border-radius: 4px; }
    </style>
    <% } %>
</body>
</html>
