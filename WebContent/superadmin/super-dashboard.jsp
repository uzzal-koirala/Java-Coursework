<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.List, model.User, service.SuperAdminService" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || !"SUPER_ADMIN".equals(sessionUser.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    List<Map<String, String>> activities = (List<Map<String, String>>) request.getAttribute("activities");

    if (stats == null || activities == null) {
        SuperAdminService superService = new SuperAdminService();
        stats = superService.getSystemStats();
        activities = superService.getSystemActivities();
    }

    int totalUsers = stats.getOrDefault("totalUsers", 0);
    int totalDepts = stats.getOrDefault("totalDepts", 0);
    int totalGunaso = stats.getOrDefault("totalGunaso", 0);
    int solvedGunaso = stats.getOrDefault("solvedGunaso", 0);
    int activeGunaso = totalGunaso - solvedGunaso;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Super Admin Core Terminal - Gunaso Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css?v=2">
    <% 
        String sysTheme = (String) application.getAttribute("sys_themeMode");
        if ("dark".equals(sysTheme)) { 
    %>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin-dark.css">
    <% } %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap">
</head>
<body>
    <div class="dashboard-wrapper">
        <jsp:include page="/components/sidebar.jsp" />
        
        <div class="main-content">
            <jsp:include page="/components/navbar.jsp" />
            
            <div class="dashboard-body">
                <!-- Welcome Banner -->
                <div class="dashboard-hero" style="background: linear-gradient(135deg, #090d16 0%, #1e1b4b 100%); border: 1px solid rgba(59, 130, 246, 0.2); box-shadow: 0 10px 30px rgba(59, 130, 246, 0.05);">
                    <div class="hero-text">
                        <span style="font-family: 'Share Tech Mono', monospace; font-size: 0.85rem; color: #3b82f6; text-transform: uppercase; letter-spacing: 2px;">Core Administration Node</span>
                        <h2 style="font-weight: 800; margin-top: 5px;">Namaste, <%= sessionUser.getFullName() %></h2>
                        <p>Welcome to the administrative command center of the Gunaso Grievance Portal. You have full root-level control over accounts, departments, and system configurations.</p>
                    </div>
                    <div class="hero-actions">
                        <a href="<%= request.getContextPath() %>/superadmin/system-settings.jsp" class="btn-lodge" style="background: #3b82f6; box-shadow: 0 10px 20px rgba(59, 130, 246, 0.2);"><i class="fa-solid fa-server"></i> System Settings</a>
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
                            <h3>Total Users</h3>
                            <div class="value"><%= totalUsers %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(59, 130, 246, 0.1); color: #3b82f6;">
                            <i class="fa-solid fa-users"></i>
                        </div>
                    </div>
                    <div class="stat-card stat-progress">
                        <div class="stat-info">
                            <h3>Departments</h3>
                            <div class="value"><%= totalDepts %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
                            <i class="fa-solid fa-building"></i>
                        </div>
                    </div>
                    <div class="stat-card stat-pending">
                        <div class="stat-info">
                            <h3>Active Grievances</h3>
                            <div class="value"><%= activeGunaso %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: #f59e0b;">
                            <i class="fa-solid fa-envelope-open-text"></i>
                        </div>
                    </div>
                    <div class="stat-card stat-resolved">
                        <div class="stat-info">
                            <h3>Resolved Grievances</h3>
                            <div class="value"><%= solvedGunaso %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: #6366f1;">
                            <i class="fa-solid fa-square-check"></i>
                        </div>
                    </div>
                </div>

                <!-- Activity Log Table -->
                <div class="section-header" style="margin-top: 50px;">
                    <h2 style="font-size: 1.8rem; font-weight: 800; letter-spacing: -0.5px;">Live System Activity Logs</h2>
                    <div style="background: rgba(59, 130, 246, 0.1); padding: 8px 15px; border-radius: 100px; border: 1px solid rgba(59, 130, 246, 0.2);">
                        <span style="font-family: 'Share Tech Mono', monospace; font-size: 0.9rem; color: #3b82f6; display: inline-flex; align-items: center; gap: 8px;">
                            <i class="fa-solid fa-circle-dot" style="animation: neonPulse 2s infinite;"></i> 
                            <strong>SECURE LINK ACTIVE</strong>
                        </span>
                    </div>
                </div>

                <div class="data-table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="font-size: 0.9rem; padding: 25px;">Timestamp</th>
                                <th style="font-size: 0.9rem; padding: 25px;">System Action / Event</th>
                                <th style="font-size: 0.9rem; padding: 25px;">Meta Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (activities != null && !activities.isEmpty()) {
                                    for (Map<String, String> act : activities) {
                                        String timestamp = act.get("time");
                                        if (timestamp != null && timestamp.length() > 19) {
                                            timestamp = timestamp.substring(0, 19);
                                        }
                            %>
                                <tr>
                                    <td class="id-col" style="font-family: 'Share Tech Mono', monospace; font-size: 1rem; color: #94a3b8 !important; padding: 20px 25px;"><%= timestamp %></td>
                                    <td class="title-col" style="font-size: 1.05rem; font-weight: 600; color: #f8fafc !important; padding: 20px 25px;"><%= act.get("activity") %></td>
                                    <td style="padding: 20px 25px;">
                                        <code style="background: rgba(0, 0, 0, 0.5); padding: 8px 12px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.05); font-size: 0.9rem; color: #3b82f6; font-family: 'Share Tech Mono', monospace;"><%= act.get("detail") %></code>
                                    </td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="3" style="text-align: center; padding: 50px; color: #64748b; font-size: 1.1rem;">
                                        <i class="fa-solid fa-server" style="font-size: 2rem; margin-bottom: 15px; opacity: 0.5; display: block;"></i>
                                        System logs are currently empty.
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

    <% if ("dark".equals(sysTheme)) { %>
    <!-- Superadmin Core Terminal Theme Overrides -->
    <style>
        /* Base Dark Mode Setup */
        body {
            background: #030712 !important; /* Deep cosmic dark */
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(59, 130, 246, 0.05), transparent 30%),
                radial-gradient(circle at 90% 80%, rgba(59, 130, 246, 0.05), transparent 30%) !important;
            color: #e2e8f0 !important;
        }
        
        .dashboard-body {
            padding: 50px 60px !important; /* Larger padding to fix "too small" look */
        }
        
        /* Sidebar Overrides */
        .sidebar {
            background: rgba(3, 7, 18, 0.8) !important;
            border-right: 1px solid rgba(255, 255, 255, 0.05) !important;
            box-shadow: 10px 0 30px rgba(0, 0, 0, 0.8) !important;
        }
        .sidebar-brand-text h2 { color: #3b82f6 !important; text-shadow: 0 0 10px rgba(59,130,246,0.3); }
        .sidebar-menu li a { color: #94a3b8 !important; font-size: 1.05rem !important; padding: 16px 20px !important; }
        .sidebar-menu li a:hover { background: rgba(59, 130, 246, 0.05) !important; color: #3b82f6 !important; transform: translateX(5px); }
        .sidebar-menu li a.active { 
            background: linear-gradient(135deg, rgba(59, 130, 246, 0.2), rgba(59, 130, 246, 0.05)) !important; 
            color: #3b82f6 !important; 
            border-left: 4px solid #3b82f6 !important;
            box-shadow: none !important;
        }
        .sidebar-profile { background: rgba(0, 0, 0, 0.4) !important; border: 1px solid rgba(255, 255, 255, 0.03) !important; }
        .profile-info h4 { color: #f8fafc !important; font-size: 1.1rem !important; }
        .profile-info span { color: #3b82f6 !important; }
        
        /* Topbar Overrides */
        .top-bar {
            background: rgba(3, 7, 18, 0.7) !important;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05) !important;
            padding: 20px 60px !important;
        }
        .page-title h1 { color: #f8fafc !important; font-size: 1.8rem !important; letter-spacing: -0.5px; }
        .search-box input { 
            background: rgba(255, 255, 255, 0.03) !important; 
            border: 1px solid rgba(255, 255, 255, 0.1) !important; 
            color: #e2e8f0 !important;
            font-size: 1rem !important;
            padding: 14px 20px 14px 45px !important;
        }
        .search-box input:focus { border-color: #3b82f6 !important; box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1) !important; }
        .notification-bell { color: #94a3b8 !important; font-size: 1.5rem !important; }
        .notification-bell:hover { color: #3b82f6 !important; }
        
        /* Hero Section Enhanced */
        .dashboard-hero {
            background: linear-gradient(135deg, #05101a 0%, #020617 100%) !important;
            border: 1px solid rgba(59, 130, 246, 0.2) !important;
            box-shadow: 0 20px 50px rgba(0,0,0,0.5), inset 0 0 60px rgba(59, 130, 246, 0.03) !important;
            padding: 50px 60px !important;
            min-height: 250px;
        }
        .dashboard-hero::before {
            content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 2px;
            background: linear-gradient(90deg, transparent, #3b82f6, transparent);
            opacity: 0.8;
        }
        .hero-text h2 { font-size: 2.8rem !important; margin: 15px 0 !important; color: #fff !important; letter-spacing: -1px; }
        .hero-text p { font-size: 1.2rem !important; color: #94a3b8 !important; max-width: 700px !important; line-height: 1.8 !important; }
        
        /* Stats Grid Enhanced */
        .stats-grid { grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)) !important; gap: 30px !important; margin-bottom: 50px !important; }
        .stat-card {
            background: rgba(15, 23, 42, 0.4) !important;
            border: 1px solid rgba(255, 255, 255, 0.03) !important;
            padding: 40px 35px !important;
            border-radius: 24px !important;
            box-shadow: 0 15px 35px rgba(0,0,0,0.3) !important;
        }
        .stat-card:hover { transform: translateY(-8px) !important; border-color: rgba(255,255,255,0.1) !important; }
        .stat-info h3 { font-size: 1.05rem !important; color: #94a3b8 !important; letter-spacing: 2px !important; margin-bottom: 12px !important; }
        .stat-info .value { font-size: 3.5rem !important; font-family: 'Share Tech Mono', monospace !important; font-weight: 400 !important; }
        
        .stat-icon { width: 80px !important; height: 80px !important; font-size: 2.2rem !important; border-radius: 20px !important; }
        
        /* Table Enhanced */
        .data-table-container {
            background: rgba(15, 23, 42, 0.4) !important;
            border: 1px solid rgba(255, 255, 255, 0.05) !important;
            border-radius: 24px !important;
            box-shadow: 0 20px 40px rgba(0,0,0,0.4) !important;
        }
        .data-table th { background: rgba(0, 0, 0, 0.6) !important; color: #94a3b8 !important; border-bottom: 1px solid rgba(255,255,255,0.05) !important; font-size: 1rem !important; letter-spacing: 1px !important; }
        .data-table td { color: #cbd5e1 !important; border-bottom: 1px solid rgba(255,255,255,0.02) !important; }
        .data-table tbody tr:hover { background: rgba(255, 255, 255, 0.02) !important; }
        
        @keyframes neonPulse {
            0% { text-shadow: 0 0 5px rgba(59,130,246,0.5); opacity: 0.5; }
            50% { text-shadow: 0 0 15px rgba(59,130,246,0.8), 0 0 25px rgba(59,130,246,0.6); opacity: 1; }
            100% { text-shadow: 0 0 5px rgba(59,130,246,0.5); opacity: 0.5; }
        }
        
        /* Fix for footer in dark mode */
        footer { background: transparent !important; color: #64748b !important; border-top: 1px solid rgba(255,255,255,0.05) !important; }
    </style>
    <% } else { %>
    <!-- Superadmin Core Terminal Light Mode Structural Adjustments -->
    <style>
        .dashboard-body {
            padding: 50px 60px !important;
        }
        .stats-grid {
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)) !important;
            gap: 30px !important;
            margin-bottom: 50px !important;
        }
        .stat-card {
            padding: 40px 35px !important;
            border-radius: 24px !important;
        }
        .stat-info .value {
            font-size: 3.5rem !important;
            font-family: 'Share Tech Mono', monospace !important;
            font-weight: 700 !important;
        }
        .stat-icon {
            width: 80px !important;
            height: 80px !important;
            font-size: 2.2rem !important;
            border-radius: 20px !important;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .data-table-container {
            border-radius: 24px !important;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03) !important;
        }
        .data-table th {
            padding: 25px !important;
        }
        .data-table td {
            padding: 20px 25px !important;
        }
        /* Dashboard Hero override for light mode */
        .dashboard-hero {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%) !important;
            border: 1px solid rgba(255, 255, 255, 0.4) !important;
            box-shadow: 0 20px 40px rgba(30, 58, 138, 0.1) !important;
            padding: 50px 60px !important;
        }
        .hero-text h2 {
            color: #ffffff !important;
        }
        .hero-text p {
            color: rgba(255, 255, 255, 0.9) !important;
        }
        .data-table td.title-col {
            color: var(--text-main) !important;
        }
        .data-table td.id-col {
            color: var(--text-light) !important;
        }
    </style>
    <% } %>
</body>
</html>
