<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Gunaso, model.User" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || !"WADA_ADAKSHYA".equals(sessionUser.getRoleName())) {
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
    <title>Ward Command Center - Gunaso Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css?v=2">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap">
    <script src="<%= request.getContextPath() %>/js/script.js" defer></script>
    <style>
        body { background: #f0fdf4; } /* Subtle green tint background */
        .dashboard-hero {
            background: linear-gradient(135deg, #065f46 0%, #047857 100%);
            border: 1px solid rgba(16, 185, 129, 0.2);
            box-shadow: 0 10px 30px rgba(6, 95, 70, 0.2);
            position: relative;
            overflow: hidden;
            border-radius: 20px;
            padding: 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #fff;
            margin-bottom: 30px;
        }
        .dashboard-hero::after {
            content: '';
            position: absolute;
            top: -50px; right: -50px;
            width: 200px; height: 200px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
        }
        .hero-text { z-index: 2; }
        .hero-actions { z-index: 2; }
        .stat-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.02);
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(6, 95, 70, 0.05); }
        .stat-info h3 { font-size: 1rem; color: #64748b; margin-bottom: 8px; font-weight: 600; }
        .stat-info .value { font-size: 2.2rem; font-weight: 800; font-family: 'Share Tech Mono', monospace; color: #064e3b; }
        .stat-icon {
            width: 60px; height: 60px;
            border-radius: 16px;
            display: flex; justify-content: center; align-items: center;
            font-size: 1.5rem;
        }
        .side-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.02);
            border: 1px solid #e2e8f0;
            margin-bottom: 30px;
        }
        .form-control {
            width: 100%;
            padding: 15px;
            border-radius: 12px;
            border: 1px solid #cbd5e1;
            background: #f8fafc;
            outline: none;
            font-family: inherit;
            margin-bottom: 15px;
            resize: vertical;
        }
        .form-control:focus { border-color: #059669; box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.1); }
        .btn-primary {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            color: #fff;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(5, 150, 105, 0.2);
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(5, 150, 105, 0.3); color: #fff; }
        .data-table th { background: #f8fafc; color: #475569; font-weight: 600; padding: 15px 20px; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; }
        .badge-pending { background: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.2); }
        .badge-in-review { background: rgba(245, 158, 11, 0.1); color: #f59e0b; border: 1px solid rgba(245, 158, 11, 0.2); }
        .badge-solved { background: rgba(16, 185, 129, 0.1); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.2); }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <jsp:include page="/components/sidebar.jsp" />
        
        <div class="main-content">
            <jsp:include page="/components/navbar.jsp" />
            
            <div class="dashboard-body" style="padding: 40px 50px;">
                
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

                <!-- Welcome Banner -->
                <div class="dashboard-hero">
                    <div class="hero-text">
                        <span style="font-family: 'Share Tech Mono', monospace; font-size: 0.9rem; color: #a7f3d0; text-transform: uppercase; letter-spacing: 3px;">Ward Office Command Center</span>
                        <h2 style="font-size: 2.2rem; font-weight: 800; margin-top: 10px; color: #ffffff;">Namaste, <%= sessionUser.getFullName() %></h2>
                        <p style="color: #ecfdf5; font-size: 1.1rem; max-width: 600px; margin-top: 10px; opacity: 0.9;">Manage citizen grievances, post local updates, and verify citizen identities seamlessly.</p>
                    </div>
                    <div class="hero-icon" style="font-size: 5rem; opacity: 0.15; transform: rotate(-5deg);">
                        <i class="fa-solid fa-house-user"></i>
                    </div>
                </div>

                <!-- Ward Stats Grid -->
                <div class="stats-grid" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px;">
                    <div class="stat-card" style="border-bottom: 4px solid #065f46;">
                        <div class="stat-info">
                            <h3>Total Assigned</h3>
                            <div class="value"><%= total %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(6, 95, 70, 0.1); color: #065f46;"><i class="fa-solid fa-layer-group"></i></div>
                    </div>
                    <div class="stat-card" style="border-bottom: 4px solid #ef4444;">
                        <div class="stat-info">
                            <h3>Pending Actions</h3>
                            <div class="value"><%= pending %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(239, 68, 68, 0.1); color: #ef4444;"><i class="fa-solid fa-clock"></i></div>
                    </div>
                    <div class="stat-card" style="border-bottom: 4px solid #f59e0b;">
                        <div class="stat-info">
                            <h3>In Progress</h3>
                            <div class="value"><%= inReview %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: #f59e0b;"><i class="fa-solid fa-bars-progress"></i></div>
                    </div>
                    <div class="stat-card" style="border-bottom: 4px solid #10b981;">
                        <div class="stat-info">
                            <h3>Resolved Cases</h3>
                            <div class="value"><%= solved %></div>
                        </div>
                        <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;"><i class="fa-solid fa-circle-check"></i></div>
                    </div>
                </div>

                <!-- Main Layout Grid -->
                <div style="display: grid; grid-template-columns: 1fr 350px; gap: 30px;">
                    
                    <!-- Left Column: Grievances Table -->
                    <div>
                        <div class="section-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                            <h2 style="font-size: 1.4rem; font-weight: 700; color: #1e293b;">Ward Grievances List</h2>
                            <div style="position: relative; width: 250px;">
                                <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #94a3b8;"></i>
                                <input type="text" id="tableSearch" onkeyup="filterGunasos()" placeholder="Search citizens or IDs..." style="width: 100%; padding: 10px 15px 10px 40px; border-radius: 10px; border: 1px solid #cbd5e1; outline: none;">
                            </div>
                        </div>

                        <div class="data-table-container" style="background: #ffffff; border-radius: 20px; box-shadow: 0 10px 20px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; overflow: hidden;">
                            <table class="data-table" id="gunasoTable" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Citizen</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        if (gunasos != null && !gunasos.isEmpty()) {
                                            for (Gunaso g : gunasos) {
                                                String badgeClass = "badge-pending";
                                                if ("In Review".equals(g.getStatus())) badgeClass = "badge-in-review";
                                                else if ("Solved".equals(g.getStatus())) badgeClass = "badge-solved";
                                    %>
                                        <tr class="gunaso-row" data-search="<%= g.getId() %> <%= g.getUserName().toLowerCase() %>" style="border-bottom: 1px solid #f1f5f9;">
                                            <td style="padding: 15px 20px; font-family: 'Share Tech Mono', monospace; font-weight: 600; color: #059669;">#<%= g.getId() %></td>
                                            <td style="padding: 15px 20px; font-weight: 600; color: #334155;"><%= g.getUserName() %></td>
                                            <td style="padding: 15px 20px;">
                                                <span class="badge <%= badgeClass %>" style="padding: 5px 10px; border-radius: 6px; font-size: 0.75rem; font-weight: 600;"><%= g.getStatus() %></span>
                                            </td>
                                            <td style="padding: 15px 20px;">
                                                <a href="<%= request.getContextPath() %>/gunaso/view?id=<%= g.getId() %>" style="color: #059669; text-decoration: none; font-weight: 600; font-size: 0.9rem; background: rgba(5, 150, 105, 0.1); padding: 6px 12px; border-radius: 6px; transition: background 0.3s;"><i class="fa-regular fa-eye"></i> View</a>
                                            </td>
                                        </tr>
                                    <% 
                                            }
                                        } else {
                                    %>
                                        <tr>
                                            <td colspan="4" style="text-align: center; padding: 40px; color: #94a3b8;">
                                                <i class="fa-regular fa-folder-open" style="font-size: 3rem; opacity: 0.3; margin-bottom: 15px; display: block;"></i>
                                                No grievances assigned to your ward/department yet.
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Right Column: Verification & Quick Post -->
                    <div>
                        
                        <!-- KYC Verification Action -->
                        <div class="side-card" style="background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%); color: #fff; border: none; box-shadow: 0 10px 25px rgba(15, 23, 42, 0.3);">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 15px;">
                                <h3 style="font-size: 1.1rem; font-weight: 700;"><i class="fa-solid fa-id-card-clip" style="color: #38bdf8; margin-right: 8px;"></i> Citizen KYC</h3>
                                <span style="background: #ef4444; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: 700;">Action Required</span>
                            </div>
                            <p style="color: #94a3b8; font-size: 0.9rem; margin-bottom: 20px;">Review and approve citizen identities for your ward to grant them system access.</p>
                            <a href="<%= request.getContextPath() %>/admin/verify-requests.jsp" class="btn-primary" style="width: 100%; background: #38bdf8; color: #0f172a; box-shadow: 0 4px 15px rgba(56, 189, 248, 0.3);">Go to Verification Panel</a>
                        </div>

                        <!-- Quick Post Form -->
                        <div class="side-card">
                            <h3 style="font-size: 1.1rem; font-weight: 700; color: #1e293b; margin-bottom: 5px;"><i class="fa-solid fa-megaphone" style="color: #059669; margin-right: 8px;"></i> Post Ward Update</h3>
                            <p style="color: #64748b; font-size: 0.9rem; margin-bottom: 20px;">Share announcements or progress with the citizens.</p>
                            
                            <form action="<%= request.getContextPath() %>/user/sarkar-updates/action" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="action" value="post">
                                <textarea name="content" class="form-control" rows="4" placeholder="Write the update here..." required></textarea>
                                <div style="margin-bottom: 15px;">
                                    <label style="font-size: 0.85rem; font-weight: 600; color: #475569; display: block; margin-bottom: 8px;">Attach Photo (Optional)</label>
                                    <input type="file" name="photo" style="width: 100%; padding: 10px; border: 1px dashed #cbd5e1; border-radius: 10px; font-size: 0.85rem; color: #64748b;">
                                </div>
                                <button type="submit" class="btn-primary" style="width: 100%;"><i class="fa-solid fa-paper-plane" style="margin-right: 5px;"></i> Publish Update</button>
                            </form>
                        </div>

                    </div>

                </div>
            </div>
            
            <jsp:include page="/components/footer.jsp" />
        </div>
    </div>

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
</body>
</html>
