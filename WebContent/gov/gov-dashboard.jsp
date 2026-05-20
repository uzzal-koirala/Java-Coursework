<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Gunaso, model.User" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null) {
        response.sendRedirect(request.getContextPath() + "/gov-portal.jsp");
        return;
    }
    String role = sessionUser.getRoleName();
    // Double check that citizens or superadmins aren't accessing this
    if ("CITIZEN".equalsIgnoreCase(role) || "SUPER_ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/gov-portal.jsp");
        return;
    }

    List<Gunaso> complaints = (List<Gunaso>) request.getAttribute("complaints");
    Integer totalComplaints      = (Integer) request.getAttribute("totalComplaints");
    Integer pendingComplaints    = (Integer) request.getAttribute("pendingComplaints");
    Integer inProgressComplaints = (Integer) request.getAttribute("inProgressComplaints");
    Integer resolvedComplaints   = (Integer) request.getAttribute("resolvedComplaints");

    int total      = totalComplaints != null ? totalComplaints : 0;
    int pending    = pendingComplaints != null ? pendingComplaints : 0;
    int inProgress = inProgressComplaints != null ? inProgressComplaints : 0;
    int resolved   = resolvedComplaints != null ? resolvedComplaints : 0;

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
    <meta name="description" content="Government Dashboard - Gunaso Management System. Manage department tickets and announcements.">
    <title>Government Dashboard - Gunaso Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css?v=2">
    <% if ("dark".equals(sysTheme)) { %>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin-dark.css">
    <% } %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap">
    <script src="<%= request.getContextPath() %>/js/script.js" defer></script>
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
            --glass-border: rgba(241, 245, 249, 0.8);
            --shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -2px rgba(0,0,0,0.05);
            --card-gradient: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
        }

        body.dark-mode {
            --card-bg: rgba(15, 23, 42, 0.9);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border: rgba(255, 255, 255, 0.08);
            --glass-bg: rgba(15, 23, 42, 0.65);
            --glass-border: rgba(255, 255, 255, 0.05);
            --shadow: 0 20px 40px rgba(0,0,0,0.4);
            --card-gradient: linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%);
        }

        .gov-body {
            padding: 30px 40px;
            font-family: 'Inter', sans-serif;
        }

        .banner-card {
            background: var(--card-gradient);
            border-radius: 20px;
            padding: 28px 35px;
            color: #ffffff;
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(255,255,255,0.05);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }

        .banner-glow {
            position: absolute;
            top: -50px;
            right: -50px;
            width: 250px;
            height: 250px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(59, 130, 246, 0.4) 0%, rgba(59,130,246,0) 70%);
            pointer-events: none;
        }

        .banner-role-badge {
            font-family: 'Share Tech Mono', monospace;
            color: #93c5fd;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-size: 0.8rem;
            display: inline-block;
            margin-bottom: 6px;
        }

        .banner-title {
            font-size: 1.85rem;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .banner-desc {
            font-size: 0.98rem;
            opacity: 0.9;
            max-width: 700px;
            line-height: 1.5;
        }

        /* Two column layout */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 30px;
        }

        @media (min-width: 1024px) {
            .dashboard-grid {
                grid-template-columns: 2fr 1fr;
            }
        }

        /* Custom Card container */
        .dashboard-card {
            background: var(--card-bg);
            border-radius: 16px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            overflow: hidden;
            padding: 25px;
            transition: transform 0.25s, box-shadow 0.25s;
        }

        .dashboard-card:hover {
            box-shadow: 0 10px 20px rgba(0,0,0,0.08);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 22px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 12px;
        }

        .card-title {
            font-size: 1.22rem;
            font-weight: 700;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-title i {
            color: var(--primary);
        }

        /* Update Form styles */
        .form-update-textarea {
            width: 100%;
            min-height: 110px;
            padding: 14px;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: var(--glass-bg);
            color: var(--text-main);
            font-size: 0.92rem;
            outline: none;
            resize: vertical;
            transition: border-color 0.25s;
            margin-bottom: 15px;
        }

        .form-update-textarea:focus {
            border-color: var(--primary);
        }

        .upload-wrapper {
            position: relative;
            margin-bottom: 18px;
        }

        .upload-btn-custom {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 15px;
            border-radius: 8px;
            border: 1px dashed var(--primary);
            background: rgba(59, 130, 246, 0.05);
            color: var(--primary);
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            justify-content: center;
            transition: background 0.2s;
        }

        .upload-btn-custom:hover {
            background: rgba(59, 130, 246, 0.1);
        }

        .upload-input-file {
            position: absolute;
            top: 0;
            left: 0;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }

        .btn-submit-announce {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            border: none;
            background: linear-gradient(135deg, var(--primary) 0%, #1d4ed8 100%);
            color: #ffffff;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(59, 130, 246, 0.25);
            transition: opacity 0.2s, transform 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit-announce:hover {
            transform: translateY(-1px);
            opacity: 0.95;
        }

        .badge-rejected {
            background: rgba(239, 68, 68, 0.12) !important;
            color: #ef4444 !important;
            border: 1px solid rgba(239, 68, 68, 0.25);
        }

        .quick-feed-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.85rem;
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            margin-top: 15px;
            transition: opacity 0.2s;
        }

        .quick-feed-link:hover {
            opacity: 0.8;
            text-decoration: underline;
        }

        .action-row-form {
            display: flex;
            gap: 6px;
        }

        .select-status {
            padding: 6px 10px;
            border-radius: 8px;
            border: 1px solid var(--border);
            background: var(--card-bg);
            color: var(--text-main);
            font-size: 0.82rem;
            outline: none;
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

        .kyc-card {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.06) 0%, rgba(16, 185, 129, 0.01) 100%);
            border: 1px solid rgba(16, 185, 129, 0.15);
            border-radius: 12px;
            padding: 18px;
            margin-top: 20px;
        }

        .kyc-card-header {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
            font-size: 0.95rem;
            color: #059669;
            margin-bottom: 8px;
        }

        .kyc-card p {
            font-size: 0.84rem;
            color: var(--text-muted);
            margin-bottom: 12px;
            line-height: 1.4;
        }

        .kyc-card-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            font-size: 0.8rem;
            background: #10b981;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            box-shadow: 0 4px 10px rgba(16, 185, 129, 0.2);
            transition: opacity 0.2s;
        }

        .kyc-card-btn:hover {
            opacity: 0.95;
        }

        /* Input styling */
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
    </style>
</head>
<body class="<%= "dark".equals(sysTheme) ? "dark-mode" : "" %>">
    <div class="dashboard-wrapper">
        <!-- Reusable Left Sidebar Component -->
        <jsp:include page="/components/sidebar.jsp" />
        
        <div class="main-content">
            <!-- Reusable Top Navbar Component -->
            <jsp:include page="/components/navbar.jsp" />
            
            <div class="gov-body">
                <!-- Welcome Command Banner -->
                <div class="banner-card">
                    <div class="banner-glow"></div>
                    <span class="banner-role-badge">Official Core Access // <%= role.replace("_", " ") %></span>
                    <h1 class="banner-title">Namaste, <%= sessionUser.getFullName() %></h1>
                    <p class="banner-desc">Welcome back to the Government Service Portal. Review civic complaints assigned to your department, evaluate status adjustments, and post official updates to build transparent communication.</p>
                </div>

                <!-- Stats Cards Row -->
                <div class="stats-grid" style="margin-bottom: 30px;">
                    <div class="stat-card" style="border-left: 4px solid var(--primary);">
                        <div class="stat-info">
                            <h3>Total Complaints</h3>
                            <div class="value"><%= total %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(59, 130, 246, 0.1); color: var(--primary);">
                            <i class="fa-solid fa-folder-open"></i>
                        </div>
                    </div>
                    <div class="stat-card" style="border-left: 4px solid var(--danger);">
                        <div class="stat-info">
                            <h3>Pending Issues</h3>
                            <div class="value"><%= pending %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(239, 68, 68, 0.1); color: var(--danger);">
                            <i class="fa-solid fa-hourglass-half"></i>
                        </div>
                    </div>
                    <div class="stat-card" style="border-left: 4px solid var(--warning);">
                        <div class="stat-info">
                            <h3>In Progress</h3>
                            <div class="value"><%= inProgress %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: var(--warning);">
                            <i class="fa-solid fa-circle-notch fa-spin"></i>
                        </div>
                    </div>
                    <div class="stat-card" style="border-left: 4px solid var(--success);">
                        <div class="stat-info">
                            <h3>Resolved</h3>
                            <div class="value"><%= resolved %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--success);">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                    </div>
                </div>

                <!-- Session Feedback messages -->
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

                <!-- Two Column Details -->
                <div class="dashboard-grid">
                    <!-- Left: Table column -->
                    <div class="dashboard-card">
                        <div class="card-header" style="flex-wrap: wrap; gap: 15px;">
                            <div class="card-title">
                                <i class="fa-solid fa-list-check"></i>
                                Assigned Citizen Grievances
                            </div>
                            <div style="position: relative; width: 100%; max-width: 250px;">
                                <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 0.85rem;"></i>
                                <input type="text" id="searchField" onkeyup="filterComplaints()" placeholder="Search citizen details...">
                            </div>
                        </div>

                        <div class="data-table-container" style="overflow-x: auto; box-shadow: none; border-radius: 0;">
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
                                    %>
                                        <tr class="complaint-row" data-search="<%= c.getId() %> <%= c.getUserName().toLowerCase() %> <%= c.getTitle().toLowerCase() %>">
                                            <td style="font-family: 'Share Tech Mono', monospace; font-weight: 700; color: var(--primary);">#<%= c.getId() %></td>
                                            <td>
                                                <div style="font-weight: 600;"><%= c.getUserName() %></div>
                                            </td>
                                            <td style="font-weight: 500; font-size: 0.92rem;"><%= c.getTitle() %></td>
                                            <td>
                                                <span class="badge badge-<%= c.getStatus().toLowerCase().replace(" ", "-") %>" style="font-size: 0.75rem; padding: 4px 10px;">
                                                    <%= c.getStatus() %>
                                                </span>
                                            </td>
                                            <td style="font-size: 0.82rem; color: var(--text-muted);"><%= c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                                            <td>
                                                <div style="display: flex; gap: 8px; justify-content: center; align-items: center;">
                                                    <a href="<%= request.getContextPath() %>/gunaso/view?id=<%= c.getId() %>" class="btn-view" style="padding: 6px 12px; font-size: 0.78rem; text-decoration: none; display: inline-flex; align-items: center; gap: 4px; background: var(--primary); color: #ffffff; border-radius: 6px; font-weight: 600;"><i class="fa-regular fa-eye"></i> View</a>
                                                    
                                                    <form action="<%= request.getContextPath() %>/gunaso/updateStatus" method="POST" class="action-row-form">
                                                        <input type="hidden" name="gunasoId" value="<%= c.getId() %>">
                                                        <select name="status" class="select-status">
                                                            <option value="Pending" <%= "Pending".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>Pending</option>
                                                            <option value="In Review" <%= "In Review".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>In Review</option>
                                                            <option value="Solved" <%= "Solved".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>Solved</option>
                                                            <option value="Rejected" <%= "Rejected".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>Rejected</option>
                                                        </select>
                                                        <button type="submit" class="btn-status-submit" title="Update status"><i class="fa-solid fa-check"></i></button>
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

                    <!-- Right: Widget column -->
                    <div style="display: flex; flex-direction: column; gap: 30px;">
                        <!-- Announcement Card -->
                        <div class="dashboard-card">
                            <div class="card-header">
                                <div class="card-title">
                                    <i class="fa-solid fa-bullhorn"></i>
                                    Broadcast Update
                                </div>
                            </div>
                            
                            <form action="<%= request.getContextPath() %>/user/sarkar-updates/action" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="action" value="post">
                                
                                <textarea name="content" class="form-update-textarea" placeholder="Enter details to announce official departmental updates, actions, or guidelines to citizens..." required></textarea>
                                
                                <div class="upload-wrapper">
                                    <label class="upload-btn-custom">
                                        <i class="fa-solid fa-camera"></i>
                                        <span>Add Photo (Optional)</span>
                                        <input type="file" name="photo" class="upload-input-file" accept="image/*" onchange="previewFile(this)">
                                    </label>
                                    <div id="filePreviewName" style="font-size: 0.78rem; color: var(--success); margin-top: 6px; font-weight: 500; display: none;"></div>
                                </div>

                                <button type="submit" class="btn-submit-announce">
                                    <i class="fa-solid fa-paper-plane"></i>
                                    Publish Announcement
                                </button>
                            </form>

                            <a href="<%= request.getContextPath() %>/user/sarkar-updates" class="quick-feed-link">
                                <i class="fa-solid fa-newspaper"></i>
                                View Live Sarkar Updates Feed
                            </a>
                        </div>

                        <!-- Ward/Wada specific card -->
                        <% if ("WADA_ADAKSHYA".equalsIgnoreCase(role)) { %>
                            <div class="dashboard-card kyc-card">
                                <div class="kyc-card-header">
                                    <i class="fa-solid fa-id-card-clip"></i>
                                    Citizen Verification Node
                                </div>
                                <p>You have clearance to evaluate citizen identity certificates (KYC) submitted in this ward. Review pending identification logs to authorize citizen profiles.</p>
                                <a href="<%= request.getContextPath() %>/admin/verify-requests.jsp" class="kyc-card-btn">
                                    Manage KYC Verification Reqs
                                    <i class="fa-solid fa-chevron-right"></i>
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Reusable Footer Component -->
            <jsp:include page="/components/footer.jsp" />
        </div>
    </div>

    <!-- Live Search & Preview helper -->
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

        function previewFile(input) {
            const file = input.files[0];
            const feedback = document.getElementById("filePreviewName");
            if (file) {
                feedback.innerText = "Selected: " + file.name + " (" + Math.round(file.size / 1024) + " KB)";
                feedback.style.display = "block";
            } else {
                feedback.style.display = "none";
            }
        }
    </script>
</body>
</html>
