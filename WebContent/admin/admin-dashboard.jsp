<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Gunaso, model.User" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || (!"WADA_ADAKSHYA".equals(sessionUser.getRoleName()) && !"NAGAR_PRAMUKH".equals(sessionUser.getRoleName()) && !"PRIME_MINISTER".equals(sessionUser.getRoleName()))) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    List<Gunaso> gunasos = (List<Gunaso>) request.getAttribute("gunasos");
    int total = 0;
    int pending = 0;
    int inReview = 0;
    int solved = 0;
    
    if (gunasos != null) {
        total = gunasos.size();
        for (Gunaso g : gunasos) {
            if ("Pending".equals(g.getStatus())) pending++;
            else if ("In Review".equals(g.getStatus())) inReview++;
            else if ("Solved".equals(g.getStatus())) solved++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Authority Dashboard - Gunaso Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css?v=2">
    <% 
        String sysTheme = (String) application.getAttribute("sys_themeMode");
        if ("dark".equals(sysTheme)) { 
    %>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin-dark.css">
    <% } %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap">
    <script src="<%= request.getContextPath() %>/js/script.js" defer></script>
</head>
<body>
    <div class="dashboard-wrapper">
        <jsp:include page="/components/sidebar.jsp" />
        
        <div class="main-content">
            <jsp:include page="/components/navbar.jsp" />
            
            <div class="dashboard-body">
                <!-- Welcome Banner -->
                <div class="dashboard-hero" style="background: linear-gradient(135deg, #0f172a 0%, #0369a1 100%); border: 1px solid rgba(14, 165, 233, 0.2); box-shadow: 0 10px 30px rgba(14, 165, 233, 0.1);">
                    <div class="hero-text">
                        <span style="font-family: 'Share Tech Mono', monospace; font-size: 0.85rem; color: #38bdf8; text-transform: uppercase; letter-spacing: 2px;">Authority Terminal // <%= sessionUser.getRoleName().replace("_", " ") %></span>
                        <h2 style="font-weight: 800; margin-top: 5px; color: #ffffff;">Namaste, <%= sessionUser.getFullName() %></h2>
                        <p style="color: #e0f2fe; opacity: 0.9;">Welcome to the Department Command Center. You have <%= pending %> pending grievances requiring your attention today. Maintain transparency and trust.</p>
                    </div>
                    <div class="hero-actions" style="display: flex; gap: 10px;">
                        <a href="<%= request.getContextPath() %>/user/sarkar-updates.jsp" class="btn-lodge" style="background: #0ea5e9; box-shadow: 0 10px 20px rgba(14, 165, 233, 0.2); border: none;"><i class="fa-solid fa-bullhorn"></i> Post Public Update</a>
                        <% if ("WADA_ADAKSHYA".equals(sessionUser.getRoleName())) { %>
                            <a href="<%= request.getContextPath() %>/admin/verify-requests.jsp" class="btn-lodge" style="background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.2);"><i class="fa-solid fa-id-card-clip"></i> Citizen KYC</a>
                        <% } %>
                    </div>
                </div>

                <!-- Alert Messages -->
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

                <!-- Stats Grid -->
                <div class="stats-grid">
                    <div class="stat-card stat-total">
                        <div class="stat-info">
                            <h3>Total Assigned</h3>
                            <div class="value"><%= total %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(14, 165, 233, 0.1); color: #0ea5e9;">
                            <i class="fa-solid fa-layer-group"></i>
                        </div>
                    </div>
                    <div class="stat-card stat-pending" style="border-left: 4px solid #ef4444;">
                        <div class="stat-info">
                            <h3>Pending</h3>
                            <div class="value"><%= pending %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(239, 68, 68, 0.1); color: #ef4444;">
                            <i class="fa-solid fa-hourglass-half"></i>
                        </div>
                    </div>
                    <div class="stat-card stat-progress" style="border-left: 4px solid #f59e0b;">
                        <div class="stat-info">
                            <h3>In Review</h3>
                            <div class="value"><%= inReview %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: #f59e0b;">
                            <i class="fa-solid fa-magnifying-glass-chart"></i>
                        </div>
                    </div>
                    <div class="stat-card stat-resolved" style="border-left: 4px solid #10b981;">
                        <div class="stat-info">
                            <h3>Solved</h3>
                            <div class="value"><%= solved %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
                            <i class="fa-solid fa-square-check"></i>
                        </div>
                    </div>
                </div>

                <div class="section-header" style="margin-top: 40px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
                    <h2 style="font-size: 1.5rem; font-weight: 700;">Department Grievances</h2>
                    <div style="position: relative; max-width: 300px; width: 100%;">
                        <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--text-light);"></i>
                        <input type="text" id="tableSearch" onkeyup="filterGunasos()" placeholder="Search citizen name or ID..." style="width: 100%; padding: 12px 15px 12px 40px; border-radius: 12px; border: 1px solid #cbd5e1; outline: none; font-size: 0.9rem; transition: all 0.3s; background: var(--glass-bg);">
                    </div>
                </div>

                <div class="data-table-container">
                    <table class="data-table" id="gunasoTable">
                        <thead>
                            <tr>
                                <th style="padding: 20px;">Grievance ID</th>
                                <th>Citizen Details</th>
                                <th>Issue Subject</th>
                                <th>Current Status</th>
                                <th>Submission Date</th>
                                <th style="text-align: center;">Action Controls</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (gunasos != null && !gunasos.isEmpty()) {
                                    for (Gunaso g : gunasos) {
                            %>
                                <tr class="gunaso-row" data-search="<%= g.getId() %> <%= g.getUserName().toLowerCase() %> <%= g.getTitle().toLowerCase() %>">
                                    <td class="id-col" style="font-family: 'Share Tech Mono', monospace; font-weight: 600; color: #0ea5e9;">#<%= g.getId() %></td>
                                    <td>
                                        <div style="font-weight: 600; font-size: 0.95rem;"><%= g.getUserName() %></div>
                                    </td>
                                    <td class="title-col" style="font-weight: 500;"><%= g.getTitle() %></td>
                                    <td>
                                        <span class="badge badge-<%= g.getStatus().toLowerCase().replace(" ", "-") %>" style="font-size: 0.75rem; padding: 6px 12px; border-radius: 100px;">
                                            <%= g.getStatus() %>
                                        </span>
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--text-light);"><%= g.getCreatedAt() != null ? g.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                                    <td>
                                        <div style="display: flex; gap: 8px; justify-content: center; align-items: center;">
                                            <a href="<%= request.getContextPath() %>/gunaso/view?id=<%= g.getId() %>" class="btn-view" style="padding: 8px 12px; font-size: 0.8rem; border-radius: 8px; border: none; cursor: pointer; text-decoration: none; color: #fff; background: var(--primary);"><i class="fa-regular fa-eye"></i> View</a>
                                            
                                            <form action="<%= request.getContextPath() %>/gunaso/updateStatus" method="POST" style="display: flex; gap: 8px;">
                                                <input type="hidden" name="gunasoId" value="<%= g.getId() %>">
                                                <select name="status" style="padding: 8px; border-radius: 8px; font-size: 0.8rem; border: 1px solid #cbd5e1; outline: none; background: #fff; color: #333;">
                                                    <option value="Pending" <%= "Pending".equals(g.getStatus()) ? "selected" : "" %>>Pending</option>
                                                    <option value="In Review" <%= "In Review".equals(g.getStatus()) ? "selected" : "" %>>In Review</option>
                                                    <option value="Solved" <%= "Solved".equals(g.getStatus()) ? "selected" : "" %>>Solved</option>
                                                    <option value="Rejected" <%= "Rejected".equals(g.getStatus()) ? "selected" : "" %>>Rejected</option>
                                                </select>
                                                <button type="submit" style="padding: 8px 12px; font-size: 0.8rem; border-radius: 8px; border: none; cursor: pointer; background: #10b981; color: #fff; transition: background 0.3s;"><i class="fa-solid fa-check"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 50px; color: #64748b; font-size: 1.05rem;">
                                        <i class="fa-regular fa-folder-open" style="font-size: 2rem; opacity: 0.5; display: block; margin-bottom: 15px;"></i>
                                        No active grievances assigned to your department.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
</div>
    </div>

    <!-- Live Search Script -->
    <script>
        function filterGunasos() {
            const input = document.getElementById("tableSearch");
            const filter = input.value.toLowerCase();
            const nodes = document.querySelectorAll('.gunaso-row');

            nodes.forEach(row => {
                if (row.getAttribute('data-search').includes(filter)) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }
    </script>

    <% if ("dark".equals(sysTheme)) { %>
    <style>
        /* Admin specific dark mode adjustments */
        body { background: #030712 !important; color: #e2e8f0 !important; }
        .dashboard-body { padding: 40px 50px !important; }
        
        .dashboard-hero {
            background: linear-gradient(135deg, #0f172a 0%, #082f49 100%) !important;
            border: 1px solid rgba(14, 165, 233, 0.3) !important;
            box-shadow: 0 20px 40px rgba(0,0,0,0.5), inset 0 0 50px rgba(14, 165, 233, 0.05) !important;
        }
        
        .sidebar { background: rgba(3, 7, 18, 0.8) !important; border-right: 1px solid rgba(255, 255, 255, 0.05) !important; }
        .top-bar { background: rgba(3, 7, 18, 0.7) !important; border-bottom: 1px solid rgba(255, 255, 255, 0.05) !important; }
        
        .stat-card {
            background: rgba(15, 23, 42, 0.4) !important;
            border: 1px solid rgba(255, 255, 255, 0.03) !important;
        }
        .stat-card:hover { border-color: rgba(255,255,255,0.1) !important; }
        .stat-info h3 { color: #94a3b8 !important; }
        .stat-info .value { font-family: 'Share Tech Mono', monospace !important; }
        
        #tableSearch {
            background: rgba(255, 255, 255, 0.03) !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
            color: #e2e8f0 !important;
        }
        #tableSearch:focus { border-color: #0ea5e9 !important; box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1) !important; }
        
        .data-table-container {
            background: rgba(15, 23, 42, 0.4) !important;
            border: 1px solid rgba(255, 255, 255, 0.05) !important;
            box-shadow: 0 20px 40px rgba(0,0,0,0.4) !important;
        }
        .data-table th { background: rgba(0, 0, 0, 0.6) !important; color: #94a3b8 !important; border-bottom: 1px solid rgba(255,255,255,0.05) !important; }
        .data-table td { color: #cbd5e1 !important; border-bottom: 1px solid rgba(255,255,255,0.02) !important; }
        .data-table tbody tr:hover { background: rgba(255, 255, 255, 0.02) !important; }
        
        .data-table select { background: #1e293b !important; color: #f8fafc !important; border-color: rgba(255,255,255,0.1) !important; }
        
        footer { background: transparent !important; color: #64748b !important; border-top: 1px solid rgba(255,255,255,0.05) !important; }
    </style>
    <% } else { %>
    <style>
        .dashboard-body { padding: 40px 50px !important; }
        .stat-info .value { font-family: 'Share Tech Mono', monospace !important; font-weight: 700 !important; }
        .data-table-container { border-radius: 16px !important; overflow: hidden; box-shadow: 0 10px 25px rgba(0,0,0,0.02) !important; }
        #tableSearch:focus { border-color: #0ea5e9 !important; box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1) !important; }
    </style>
    <% } %>
</body>
</html>
