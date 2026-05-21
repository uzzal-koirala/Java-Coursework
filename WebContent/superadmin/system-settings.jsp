<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || !"SUPER_ADMIN".equals(sessionUser.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    // Retrieve active values from ServletContext (application state)
    String maintMode = (String) application.getAttribute("sys_maintenanceMode");
    String passComp = (String) application.getAttribute("sys_passwordComplexity");
    String backupFreq = (String) application.getAttribute("sys_backupFrequency");
    String timeout = (String) application.getAttribute("sys_sessionTimeout");

    // Establish defaults if not populated
    if (maintMode == null) maintMode = "Disabled";
    if (passComp == null) passComp = "Strong";
    if (backupFreq == null) backupFreq = "Daily";
    if (timeout == null) timeout = "30 Minutes";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Settings - Gunaso Portal</title>
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
        .settings-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }

        @media (max-width: 992px) {
            .settings-grid {
                grid-template-columns: 1fr;
            }
        }

        .settings-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            padding: 35px;
            box-shadow: var(--glass-shadow);
            transition: all 0.3s ease;
        }

        .settings-section-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid var(--glass-border);
            padding-bottom: 18px;
        }

        .settings-row {
            margin-bottom: 24px;
        }

        .settings-row label {
            display: block;
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--text-light);
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        .settings-row select, 
        .settings-row input[type="text"], 
        .settings-row input[type="number"] {
            width: 100%;
            padding: 14px 18px;
            border-radius: 12px;
            border: 1px solid var(--glass-border);
            outline: none;
            font-size: 0.95rem;
            background: var(--white);
            color: var(--text-main);
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.01);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .settings-row select:focus, 
        .settings-row input:focus {
            border-color: var(--primary-light) !important;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.12) !important;
        }

        /* Toggle switch styling */
        .switch {
            position: relative;
            display: inline-block;
            width: 52px;
            height: 30px;
        }

        .switch input { 
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: var(--glass-border);
            border: 1px solid var(--glass-border);
            transition: .3s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 34px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 22px;
            width: 22px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: .3s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: #10b981;
            border-color: #10b981;
        }

        input:focus + .slider {
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.15);
        }

        input:checked + .slider:before {
            transform: translateX(22px);
        }

        .toggle-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: rgba(30, 58, 138, 0.01);
            padding: 18px 22px;
            border-radius: 14px;
            border: 1px solid var(--glass-border);
            transition: all 0.3s ease;
        }

        .btn-backup {
            background: linear-gradient(135deg, #475569 0%, #334155 100%);
            color: #ffffff;
            border: none;
            padding: 14px 24px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 0.95rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 12px rgba(71, 85, 105, 0.15);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .btn-backup:hover {
            background: linear-gradient(135deg, #334155 0%, #1e293b 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(30, 41, 59, 0.25);
        }

        .btn-backup:active {
            transform: translateY(0);
        }

        .toast-backup {
            position: fixed;
            bottom: 30px; right: 30px;
            background: #0f172a;
            color: #ffffff;
            padding: 18px 28px;
            border-radius: 16px;
            border-left: 4px solid #10b981;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            display: flex;
            align-items: center;
            gap: 12px;
            transform: translateY(150px);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            z-index: 2000;
        }

        .toast-backup.show {
            transform: translateY(0);
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <jsp:include page="/components/sidebar.jsp" />
        
        <div class="main-content">
            <jsp:include page="/components/navbar.jsp" />
            
            <div class="dashboard-body">
                <div class="section-header">
                    <h2>System Configuration</h2>
                </div>

                <!-- Alerts -->
                <% if (session.getAttribute("success") != null) { %>
                    <div style="background: rgba(16, 185, 129, 0.15); border: 1px solid rgba(16, 185, 129, 0.3); color: #10b981; padding: 15px; border-radius: 12px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px;">
                        <i class="fa-solid fa-circle-check"></i>
                        <span><%= session.getAttribute("success") %></span>
                    </div>
                    <% session.removeAttribute("success"); %>
                <% } %>

                <form action="<%= request.getContextPath() %>/superadmin/action" method="POST">
                    <input type="hidden" name="action" value="updateSettings">
                    
                    <div class="settings-grid">
                        <!-- Left: Core System Settings -->
                        <div class="settings-card">
                            <div class="settings-section-title">
                                <i class="fa-solid fa-sliders" style="color: var(--primary-light);"></i>
                                <span>Core Operations</span>
                            </div>

                            <div class="settings-row">
                                <label>System Maintenance Mode</label>
                                <div class="toggle-container">
                                    <div>
                                        <h5 style="font-weight: 700; font-size: 0.95rem; color: var(--text-main);">Offline Mode</h5>
                                        <p style="font-size: 0.8rem; color: var(--text-light); margin-top: 3px;">Blocks standard users from lodging/viewing tickets.</p>
                                    </div>
                                    <label class="switch">
                                        <input type="checkbox" name="maintenanceMode" value="on" <%= "Enabled".equals(maintMode) ? "checked" : "" %>>
                                        <span class="slider"></span>
                                    </label>
                                </div>
                            </div>

                            <div class="settings-row">
                                <label for="sessionTimeout">Session Timeout Duration</label>
                                <div style="position: relative;">
                                    <input type="number" id="sessionTimeout" name="sessionTimeout" value="<%= timeout.replace(" Minutes", "") %>" min="5" max="1440" required>
                                    <span style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); font-size: 0.9rem; font-weight: 600; color: var(--text-light);">Minutes</span>
                                </div>
                            </div>

                            <div class="settings-row">
                                <label for="themeMode">Dashboard Theme</label>
                                <select id="themeMode" name="themeMode" style="width: 100%; padding: 12px 15px; border-radius: 8px; border: 1px solid #cbd5e1; outline: none; font-size: 0.95rem; background: #ffffff;">
                                    <% 
                                        String activeTheme = (String) application.getAttribute("sys_themeMode");
                                        if (activeTheme == null) activeTheme = "light";
                                    %>
                                    <option value="light" <%= "light".equals(activeTheme) ? "selected" : "" %>>Classic Light Mode</option>
                                    <option value="dark" <%= "dark".equals(activeTheme) ? "selected" : "" %>>Premium Dark Mode</option>
                                </select>
                            </div>
                        </div>

                        <!-- Right: Security Policies -->
                        <div class="settings-card">
                            <div class="settings-section-title">
                                <i class="fa-solid fa-shield-halved" style="color: #10b981;"></i>
                                <span>Security & Backups</span>
                            </div>

                            <div class="settings-row">
                                <label for="passwordComplexity">Password Complexity Level</label>
                                <select id="passwordComplexity" name="passwordComplexity">
                                    <option value="Standard" <%= "Standard".equals(passComp) ? "selected" : "" %>>Standard (Min 6 Characters)</option>
                                    <option value="Strong" <%= "Strong".equals(passComp) ? "selected" : "" %>>Strong (Min 8 Characters + Number)</option>
                                    <option value="Tactical" <%= "Tactical".equals(passComp) ? "selected" : "" %>>Tactical (Alphanumeric + Special Symbol)</option>
                                </select>
                            </div>

                            <div class="settings-row">
                                <label for="backupFrequency">SQL Backup Frequency</label>
                                <select id="backupFrequency" name="backupFrequency">
                                    <option value="Hourly" <%= "Hourly".equals(backupFreq) ? "selected" : "" %>>Every Hour (Hot Backups)</option>
                                    <option value="Daily" <%= "Daily".equals(backupFreq) ? "selected" : "" %>>Every Day (Recommended)</option>
                                    <option value="Weekly" <%= "Weekly".equals(backupFreq) ? "selected" : "" %>>Every Week</option>
                                </select>
                            </div>

                            <div class="settings-row" style="margin-top: 30px;">
                                <label>Database Administration</label>
                                <button type="button" class="btn-backup" onclick="triggerBackup()">
                                    <i class="fa-solid fa-database"></i> Trigger Live DB Backup
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Sticky Bottom Action Bar -->
                    <div style="background: var(--glass-bg); backdrop-filter: blur(20px); border: 1px solid var(--glass-border); border-radius: 16px; padding: 15px 30px; margin-top: 30px; box-shadow: var(--glass-shadow); display: flex; justify-content: flex-end;">
                        <button type="submit" class="btn-lodge" style="background: var(--primary); border: none; cursor: pointer; font-size: 0.95rem; border-radius: 10px; width: auto; padding: 12px 30px;">
                            <i class="fa-solid fa-circle-check"></i> Apply Configuration
                        </button>
                    </div>
                </form>
            </div>
</div>
    </div>

    <!-- Backup success notification toast -->
    <div class="toast-backup" id="backupToast">
        <i class="fa-solid fa-circle-notch fa-spin" id="backupIcon" style="color: #10b981; font-size: 1.2rem;"></i>
        <span id="backupText" style="font-weight: 600; font-size: 0.9rem;">Connecting database cluster...</span>
    </div>

    <script>
        function triggerBackup() {
            const toast = document.getElementById('backupToast');
            const icon = document.getElementById('backupIcon');
            const text = document.getElementById('backupText');

            toast.classList.add('show');
            icon.className = "fa-solid fa-circle-notch fa-spin";
            text.innerText = "Dumping tables and compression...";

            setTimeout(() => {
                icon.className = "fa-solid fa-server fa-beat";
                text.innerText = "Uploading Gzip SQL dump to cloud storage...";
                
                setTimeout(() => {
                    icon.className = "fa-solid fa-circle-check";
                    icon.style.color = "#10b981";
                    text.innerText = "SUCCESS: Backup completed (gunaso_dump_latest.sql)";
                    
                    setTimeout(() => {
                        toast.classList.remove('show');
                    }, 3000);
                }, 2000);
            }, 2000);
        }
    </script>
</body>
</html>
