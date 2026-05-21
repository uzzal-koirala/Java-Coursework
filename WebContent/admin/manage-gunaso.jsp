<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Gunaso, model.User, service.GunasoService" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    String role = sessionUser.getRoleName();
    // Only allow government officials
    if ("CITIZEN".equalsIgnoreCase(role) || "SUPER_ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    GunasoService gunasoService = new GunasoService();
    List<Gunaso> complaints;
    if ("PRIME_MINISTER".equalsIgnoreCase(role)) {
        complaints = gunasoService.getAllGunasos();
    } else {
        Integer deptId = sessionUser.getDeptId();
        if (deptId == null || deptId <= 0) {
            complaints = gunasoService.getAllGunasos();
        } else {
            complaints = gunasoService.getAssignedGunasos(deptId);
        }
    }

    String sysTheme = (String) session.getAttribute("userThemeMode");
    if (sysTheme == null) {
        sysTheme = (String) application.getAttribute("sys_themeMode");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assigned Grievances - Gunaso Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css?v=2">
    <% if ("dark".equals(sysTheme)) { %>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin-dark.css">
    <% } %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap">
    <style>
        :root {
            --primary: #3b82f6;
            --primary-hover: #2563eb;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --glass-bg: rgba(255, 255, 255, 0.7);
            --shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -2px rgba(0,0,0,0.05);
        }

        body.dark-mode {
            --card-bg: rgba(15, 23, 42, 0.9);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border: rgba(255, 255, 255, 0.08);
            --glass-bg: rgba(15, 23, 42, 0.65);
            --shadow: 0 20px 40px rgba(0,0,0,0.4);
        }

        .gov-body {
            padding: 30px 40px;
            font-family: 'Inter', sans-serif;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .section-title {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-main);
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            color: var(--primary);
        }

        .data-table-container {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 20px;
            box-shadow: var(--shadow);
            overflow: hidden;
            padding: 10px;
            transition: transform 0.25s, box-shadow 0.25s;
        }

        /* Search input styling */
        #searchField {
            background: var(--glass-bg);
            border: 1px solid var(--border);
            color: var(--text-main);
            padding: 10px 14px 10px 36px;
            border-radius: 10px;
            font-size: 0.88rem;
            outline: none;
            transition: border-color 0.2s;
        }

        #searchField:focus {
            border-color: var(--primary);
        }

        /* Modal styling */
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.4); backdrop-filter: blur(8px);
            z-index: 99999; display: flex; justify-content: center; align-items: center;
            opacity: 0; pointer-events: none; transition: all 0.3s ease;
        }
        .modal-overlay.active { opacity: 1; pointer-events: auto; }
        .modal-content-card {
            background: var(--card-bg); border-radius: 24px; width: 100%; max-width: 800px;
            box-shadow: 0 30px 60px -15px rgba(15, 23, 42, 0.3);
            transform: scale(0.92); transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); overflow: hidden;
            display: flex; flex-direction: column; height: 85vh;
            border: 1px solid var(--border);
        }
        .modal-overlay.active .modal-content-card { transform: scale(1); }
        .modal-header {
            background: linear-gradient(135deg, var(--primary) 0%, #1e40af 100%); color: #ffffff; padding: 22px 28px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 20px rgba(30, 58, 138, 0.15);
        }
        .modal-close-btn { background: none; border: none; color: #ffffff; font-size: 1.3rem; cursor: pointer; opacity: 0.8; transition: all 0.2s; }
        .modal-close-btn:hover { opacity: 1; transform: rotate(90deg); }

        .select-status {
            padding: 6px 12px;
            border-radius: 8px;
            border: 1px solid var(--border);
            background: var(--card-bg);
            color: var(--text-main);
            font-size: 0.85rem;
            outline: none;
            cursor: pointer;
            transition: border-color 0.2s;
        }
        .select-status:focus {
            border-color: var(--primary);
        }

        .btn-status-submit {
            background: var(--success);
            color: #ffffff;
            border: none;
            border-radius: 8px;
            width: 32px;
            height: 32px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: opacity 0.2s;
        }
        .btn-status-submit:hover {
            opacity: 0.9;
        }

        .badge-rejected {
            background: rgba(239, 68, 68, 0.12) !important;
            color: #ef4444 !important;
            border: 1px solid rgba(239, 68, 68, 0.25);
        }
    </style>
</head>
<body class="<%= "dark".equals(sysTheme) ? "dark-mode" : "" %>">
    <div class="dashboard-wrapper">
        <jsp:include page="/components/sidebar.jsp" />
        
        <div class="main-content">
            <jsp:include page="/components/navbar.jsp" />
            
            <div class="gov-body">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fa-solid fa-list-check"></i>
                        Assigned Grievances
                    </h2>
                    
                    <div style="display: flex; gap: 15px; align-items: center;">
                        <div style="position: relative; width: 100%; max-width: 250px;">
                            <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 0.85rem;"></i>
                            <input type="text" id="searchField" onkeyup="filterComplaints()" placeholder="Search citizen or issue...">
                        </div>
                        
                        <div style="background: rgba(59, 130, 246, 0.1); padding: 8px 15px; border-radius: 100px; border: 1px solid rgba(59, 130, 246, 0.2);">
                            <span style="font-family: 'Share Tech Mono', monospace; font-size: 0.9rem; color: #3b82f6; display: inline-flex; align-items: center; gap: 8px;">
                                <i class="fa-solid fa-circle-dot" style="animation: neonPulse 2s infinite;"></i> 
                                <strong><%= role.replace("_", " ") %> VIEW</strong>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Session messages -->
                <% if (session.getAttribute("success") != null) { %>
                    <div style="background: rgba(16, 185, 129, 0.12); border: 1px solid rgba(16, 185, 129, 0.2); color: #10b981; padding: 14px; border-radius: 10px; margin-bottom: 25px; display: flex; align-items: center; gap: 8px; font-size: 0.9rem;">
                        <i class="fa-solid fa-circle-check"></i>
                        <span><%= session.getAttribute("success") %></span>
                    </div>
                    <% session.removeAttribute("success"); %>
                <% } %>
                <% if (session.getAttribute("error") != null) { %>
                    <div style="background: rgba(239, 68, 68, 0.12); border: 1px solid rgba(239, 68, 68, 0.2); color: #ef4444; padding: 14px; border-radius: 10px; margin-bottom: 25px; display: flex; align-items: center; gap: 8px; font-size: 0.9rem;">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <span><%= session.getAttribute("error") %></span>
                    </div>
                    <% session.removeAttribute("error"); %>
                <% } %>

                <div class="data-table-container" style="overflow-x: auto;">
                    <table class="data-table" id="complaintsTable">
                        <thead>
                            <tr>
                                <th style="padding: 15px 10px;">ID</th>
                                <th>Citizen</th>
                                <th>Issue Description</th>
                                <th>Status</th>
                                <th>Created Date</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (complaints != null && !complaints.isEmpty()) {
                                for (Gunaso c : complaints) {
                                    String badgeClass = "badge-pending";
                                    String status = c.getStatus().toLowerCase();
                                    if (status.contains("review") || status.contains("progress")) badgeClass = "badge-review";
                                    if (status.contains("solve") || status.contains("resolv")) badgeClass = "badge-resolved";
                                    if (status.contains("reject")) badgeClass = "badge-rejected";
                            %>
                                <tr class="complaint-row" data-search="<%= c.getId() %> <%= c.getUserName().toLowerCase() %> <%= c.getTitle().toLowerCase() %>">
                                    <td style="font-family: 'Share Tech Mono', monospace; font-weight: 700; color: var(--primary);">#<%= c.getId() %></td>
                                    <td>
                                        <div style="font-weight: 600;"><%= c.getUserName() %></div>
                                    </td>
                                    <td style="font-weight: 500; font-size: 0.92rem;"><%= c.getTitle() %></td>
                                    <td>
                                        <span class="badge <%= badgeClass %>" style="font-size: 0.75rem; padding: 4px 10px;">
                                            <%= c.getStatus() %>
                                        </span>
                                    </td>
                                    <td style="font-size: 0.82rem; color: var(--text-muted);"><%= c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0, 16) : "N/A" %></td>
                                    <td>
                                        <div style="display: flex; gap: 8px; justify-content: center; align-items: center;">
                                            <button type="button" onclick="openViewModal('<%= request.getContextPath() %>/gunaso/view?id=<%= c.getId() %>&popup=true')" class="btn-view" style="padding: 6px 12px; font-size: 0.78rem; border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 4px; background: var(--primary); color: #ffffff; border-radius: 6px; font-weight: 600;"><i class="fa-regular fa-eye"></i> View & Reply</button>
                                            
                                            <form action="<%= request.getContextPath() %>/gunaso/updateStatus" method="POST" style="margin: 0; display: flex; gap: 6px;">
                                                <input type="hidden" name="gunasoId" value="<%= c.getId() %>">
                                                <select name="status" class="select-status" onchange="this.form.submit()">
                                                    <option value="Pending" <%= "Pending".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>Pending</option>
                                                    <option value="In Review" <%= "In Review".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>In Review</option>
                                                    <option value="Solved" <%= "Solved".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>Solved</option>
                                                    <option value="Rejected" <%= "Rejected".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>Rejected</option>
                                                </select>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                        <i class="fa-regular fa-folder-open" style="font-size: 2.2rem; opacity: 0.4; display: block; margin-bottom: 12px;"></i>
                                        No active complaints assigned to your department.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
</div>
    </div>

    <!-- Detailed View Iframe Modal -->
    <div class="modal-overlay" id="viewGunasoModal">
        <div class="modal-content-card">
            <div class="modal-header">
                <h3 style="font-weight: 700; margin: 0; color: #ffffff;">Gunaso Details</h3>
                <button class="modal-close-btn" onclick="closeViewModal()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <div style="flex-grow: 1; padding: 0;">
                <iframe id="viewIframe" src="" style="width: 100%; height: 100%; border: none;"></iframe>
            </div>
        </div>
    </div>

    <script>
        function filterComplaints() {
            const input = document.getElementById("searchField");
            const filter = input.value.toLowerCase();
            const rows = document.querySelectorAll('.complaint-row');

            rows.forEach(row => {
                const searchTxt = row.getAttribute('data-search');
                if (searchTxt && searchTxt.includes(filter)) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }

        function openViewModal(url) {
            document.getElementById('viewIframe').src = url;
            document.getElementById('viewGunasoModal').classList.add('active');
        }

        function closeViewModal() {
            document.getElementById('viewGunasoModal').classList.remove('active');
            document.getElementById('viewIframe').src = "";
            // Reload page to reflect potential replies or status updates made in the modal
            location.reload();
        }

        window.onclick = function(event) {
            var viewModal = document.getElementById('viewGunasoModal');
            if (event.target == viewModal) {
                closeViewModal();
            }
        }
    </script>
    
    <% if ("dark".equals(sysTheme)) { %>
    <style>
        body {
            background: #030712 !important;
            color: #e2e8f0 !important;
        }
        .data-table th { background: rgba(0, 0, 0, 0.6) !important; color: #94a3b8 !important; border-bottom: 1px solid rgba(255,255,255,0.05) !important; }
        .data-table td { color: #cbd5e1 !important; border-bottom: 1px solid rgba(255,255,255,0.02) !important; }
        .data-table tbody tr:hover { background: rgba(255, 255, 255, 0.02) !important; }
        
        .select-status {
            background: rgba(0, 0, 0, 0.5) !important;
            color: #e2e8f0 !important;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
        }
        .select-status:focus {
            border-color: #3b82f6 !important;
        }
        .select-status option {
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
