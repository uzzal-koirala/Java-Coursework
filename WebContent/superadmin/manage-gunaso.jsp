<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Gunaso, model.User" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || !"SUPER_ADMIN".equals(sessionUser.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage All Grievances - Core Terminal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <% 
        String sysTheme = (String) application.getAttribute("sys_themeMode");
        if ("dark".equals(sysTheme)) { 
    %>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin-dark.css">
    <% } %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap">
    <style>
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.4); backdrop-filter: blur(8px);
            z-index: 99999; display: flex; justify-content: center; align-items: center;
            opacity: 0; pointer-events: none; transition: all 0.3s ease;
        }
        .modal-overlay.active { opacity: 1; pointer-events: auto; }
        .modal-content-card {
            background: rgba(255, 255, 255, 0.96); border-radius: 24px; width: 100%; max-width: 800px;
            box-shadow: 0 30px 60px -15px rgba(15, 23, 42, 0.3), 0 0 0 1px rgba(255, 255, 255, 0.5) inset;
            transform: scale(0.92); transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); overflow: hidden;
            backdrop-filter: blur(10px); display: flex; flex-direction: column; height: 85vh;
        }
        .modal-overlay.active .modal-content-card { transform: scale(1); }
        .modal-header {
            background: linear-gradient(135deg, var(--primary, #3b82f6) 0%, #1e40af 100%); color: #ffffff; padding: 22px 28px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 20px rgba(30, 58, 138, 0.15);
        }
        .modal-close-btn { background: none; border: none; color: #ffffff; font-size: 1.3rem; cursor: pointer; opacity: 0.8; transition: all 0.2s; }
        .modal-close-btn:hover { opacity: 1; transform: rotate(90deg); }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <jsp:include page="/components/sidebar.jsp" />
        
        <div class="main-content">
            <jsp:include page="/components/navbar.jsp" />
            
            <div class="dashboard-body">
                <div class="section-header">
                    <h2 style="font-size: 1.8rem; font-weight: 800; letter-spacing: -0.5px;">Global Grievance Database</h2>
                    <div style="background: rgba(59, 130, 246, 0.1); padding: 8px 15px; border-radius: 100px; border: 1px solid rgba(59, 130, 246, 0.2);">
                        <span style="font-family: 'Share Tech Mono', monospace; font-size: 0.9rem; color: #3b82f6; display: inline-flex; align-items: center; gap: 8px;">
                            <i class="fa-solid fa-circle-dot" style="animation: neonPulse 2s infinite;"></i> 
                            <strong>ALL DEPARTMENTS</strong>
                        </span>
                    </div>
                </div>

                <% if (session.getAttribute("success") != null) { %>
                    <div style="background: rgba(16, 185, 129, 0.15); border: 1px solid rgba(16, 185, 129, 0.3); color: #10b981; padding: 15px; border-radius: 12px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px;">
                        <i class="fa-solid fa-circle-check"></i>
                        <span><%= session.getAttribute("success") %></span>
                    </div>
                    <% session.removeAttribute("success"); %>
                <% } %>
                
                <% if (session.getAttribute("error") != null) { %>
                    <div style="background: rgba(239, 68, 68, 0.15); border: 1px solid rgba(239, 68, 68, 0.3); color: #ef4444; padding: 15px; border-radius: 12px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px;">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <span><%= session.getAttribute("error") %></span>
                    </div>
                    <% session.removeAttribute("error"); %>
                <% } %>

                <div class="data-table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Tracking ID</th>
                                <th>Title</th>
                                <th>Department</th>
                                <th>Citizen</th>
                                <th>Filed Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<Gunaso> gunasos = (List<Gunaso>) request.getAttribute("gunasos");
                                if (gunasos != null && !gunasos.isEmpty()) {
                                    for (Gunaso g : gunasos) {
                                        String badgeClass = "badge-pending";
                                        String status = g.getStatus().toLowerCase();
                                        if (status.contains("review") || status.contains("progress")) badgeClass = "badge-review";
                                        if (status.contains("solve") || status.contains("resolv")) badgeClass = "badge-resolved";
                                        if (status.contains("reject")) badgeClass = "badge-rejected";
                            %>
                                <tr>
                                    <td class="id-col" style="font-family: 'Share Tech Mono', monospace; font-size: 1rem;">#<%= g.getId() %></td>
                                    <td class="title-col" style="font-weight: 600;"><%= g.getTitle() %></td>
                                    <td><%= g.getDeptName() %></td>
                                    <td><%= g.getUserName() %></td>
                                    <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(g.getCreatedAt()) %></td>
                                    <td>
                                        <form action="<%= request.getContextPath() %>/gunaso/updateStatus" method="POST" style="margin: 0; display: flex; gap: 10px; align-items: center;">
                                            <input type="hidden" name="gunasoId" value="<%= g.getId() %>">
                                            <select name="status" class="status-select" style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; outline: none; background: #f8fafc; font-size: 0.9rem;" onchange="this.form.submit()">
                                                <option value="Pending" <%= "Pending".equals(g.getStatus()) ? "selected" : "" %>>Pending</option>
                                                <option value="In Review" <%= "In Review".equals(g.getStatus()) ? "selected" : "" %>>In Review</option>
                                                <option value="Solved" <%= "Solved".equals(g.getStatus()) ? "selected" : "" %>>Solved</option>
                                                <option value="Rejected" <%= "Rejected".equals(g.getStatus()) ? "selected" : "" %>>Rejected</option>
                                            </select>
                                        </form>
                                    </td>
                                    <td>
                                        <button type="button" onclick="openViewModal('<%= request.getContextPath() %>/gunaso/view?id=<%= g.getId() %>&popup=true')" class="btn-view" style="background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.3); color: #3b82f6; padding: 6px 12px; border-radius: 6px; cursor: pointer; font-size: 0.9rem; display: inline-flex; align-items: center; gap: 5px;">
                                            <i class="fa-regular fa-eye"></i> View & Reply
                                        </button>
                                    </td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 50px; color: #64748b; font-size: 1.1rem;">
                                        <i class="fa-solid fa-server" style="font-size: 2rem; margin-bottom: 15px; opacity: 0.5; display: block;"></i>
                                        Database is empty. No grievances found.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <jsp:include page="/components/footer.jsp" />
        </div>
    </div>

    <!-- View Gunaso Iframe Modal -->
    <div class="modal-overlay" id="viewGunasoModal">
        <div class="modal-content-card">
            <div class="modal-header">
                <h3 style="font-weight: 700; margin: 0;">Grievance Details</h3>
                <button class="modal-close-btn" onclick="closeViewModal()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <div style="flex-grow: 1; padding: 0;">
                <iframe id="viewIframe" src="" style="width: 100%; height: 100%; border: none;"></iframe>
            </div>
        </div>
    </div>

    <script>
        function openViewModal(url) {
            document.getElementById('viewIframe').src = url;
            document.getElementById('viewGunasoModal').classList.add('active');
        }

        function closeViewModal() {
            document.getElementById('viewGunasoModal').classList.remove('active');
            document.getElementById('viewIframe').src = "";
        }

        window.onclick = function(event) {
            var viewModal = document.getElementById('viewGunasoModal');
            if (event.target == viewModal) {
                closeViewModal();
            }
        }
    </script>

    <% if ("dark".equals(sysTheme)) { %>
    <!-- Superadmin Core Terminal Theme Overrides for Data Table -->
    <style>
        body {
            background: #030712 !important;
            color: #e2e8f0 !important;
        }
        .data-table-container {
            background: rgba(15, 23, 42, 0.4) !important;
            border: 1px solid rgba(255, 255, 255, 0.05) !important;
            border-radius: 24px !important;
            box-shadow: 0 20px 40px rgba(0,0,0,0.4) !important;
        }
        .data-table th { background: rgba(0, 0, 0, 0.6) !important; color: #94a3b8 !important; border-bottom: 1px solid rgba(255,255,255,0.05) !important; }
        .data-table td { color: #cbd5e1 !important; border-bottom: 1px solid rgba(255,255,255,0.02) !important; }
        .data-table tbody tr:hover { background: rgba(255, 255, 255, 0.02) !important; }
        
        .status-select {
            background: rgba(0, 0, 0, 0.5) !important;
            color: #e2e8f0 !important;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
        }
        .status-select:focus {
            border-color: #3b82f6 !important;
        }
        .status-select option {
            background: #0f172a;
            color: #e2e8f0;
        }
        
        @keyframes neonPulse {
            0% { text-shadow: 0 0 5px rgba(59,130,246,0.5); opacity: 0.5; }
            50% { text-shadow: 0 0 15px rgba(59,130,246,0.8), 0 0 25px rgba(59,130,246,0.6); opacity: 1; }
            100% { text-shadow: 0 0 5px rgba(59,130,246,0.5); opacity: 0.5; }
        }
    </style>
    <% } %>
</body>
</html>
