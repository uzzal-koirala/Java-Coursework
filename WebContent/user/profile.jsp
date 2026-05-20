<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Gunaso Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <script src="<%= request.getContextPath() %>/js/script.js" defer></script>
</head>
<body>
    <div class="dashboard-wrapper">
        <jsp:include page="/components/sidebar.jsp" />
        
        <main class="main-content">
            <div class="top-bar">
                <div class="page-title">
                    <h1>Settings & Verification</h1>
                    <p>Manage your profile and upload verification documents</p>
                </div>
            </div>
            
            <div class="dashboard-body">
                <% 
                    User u = (User) session.getAttribute("user"); 
                    String vStatus = u != null ? u.getVerificationStatus() : "Unverified";
                    
                    String badgeClass = "badge-pending";
                    String icon = "fa-clock";
                    if("Verified".equals(vStatus)) {
                        badgeClass = "badge-resolved";
                        icon = "fa-check-circle";
                    } else if ("Unverified".equals(vStatus)) {
                        badgeClass = "badge-rejected";
                        icon = "fa-circle-xmark";
                    }
                %>

                <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 30px; align-items: start;">
                    
                    <!-- Left Column: Profile Card + Theme Settings -->
                    <div style="display: flex; flex-direction: column; gap: 20px;">
                        
                        <!-- Premium Profile Info Card -->
                        <div class="stat-card" style="flex-direction: column; align-items: center; padding: 40px 20px; text-align: center; background: var(--white); position: relative; overflow: hidden; margin-bottom: 0;">
                            <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100px; background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);"></div>
                            
                            <% if(u.getAvatar() != null && !u.getAvatar().isEmpty()) { %>
                                <div style="width: 120px; height: 120px; border-radius: 50%; background-image: url('<%= request.getContextPath() %>/<%= u.getAvatar() %>'); background-size: cover; background-position: center; margin-bottom: 20px; box-shadow: 0 8px 20px rgba(0,0,0,0.15); position: relative; z-index: 2; border: 4px solid white;"></div>
                            <% } else { %>
                                <div style="width: 120px; height: 120px; border-radius: 50%; background: var(--white); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 3.5rem; font-weight: 800; margin-bottom: 20px; box-shadow: 0 8px 20px rgba(0,0,0,0.15); position: relative; z-index: 2; border: 4px solid #f1f5f9;">
                                    <%= u.getFullName().substring(0, 1).toUpperCase() %>
                                </div>
                            <% } %>
                            
                            <h2 style="font-size: 1.5rem; color: var(--text-main); margin-bottom: 5px; font-weight: 700;"><%= u.getFullName() %></h2>
                            <div class="badge <%= badgeClass %>" style="font-size: 0.85rem; padding: 6px 14px; margin-bottom: 25px;">
                                <i class="fa-solid <%= icon %>" style="margin-right: 5px;"></i> <%= vStatus %> Citizen
                            </div>
                            
                            <div style="width: 100%; text-align: left; background: #f8fafc; border-radius: 12px; padding: 20px; border: 1px solid #e2e8f0;">
                                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 15px;">
                                    <div style="width: 35px; height: 35px; border-radius: 8px; background: rgba(59,130,246,0.1); color: var(--primary-light); display: flex; align-items: center; justify-content: center;"><i class="fa-solid fa-envelope"></i></div>
                                    <div>
                                        <div style="font-size: 0.75rem; color: var(--text-light); text-transform: uppercase; font-weight: 600;">Email Address</div>
                                        <div style="font-weight: 500; color: var(--text-main);"><%= u.getEmail() %></div>
                                    </div>
                                </div>
                                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 15px;">
                                    <div style="width: 35px; height: 35px; border-radius: 8px; background: rgba(16,185,129,0.1); color: #10b981; display: flex; align-items: center; justify-content: center;"><i class="fa-solid fa-phone"></i></div>
                                    <div>
                                        <div style="font-size: 0.75rem; color: var(--text-light); text-transform: uppercase; font-weight: 600;">Phone Number</div>
                                        <div style="font-weight: 500; color: var(--text-main);"><%= u.getPhone() %></div>
                                    </div>
                                </div>
                                <% if(u.getCitizenshipNo() != null && !u.getCitizenshipNo().isEmpty()) { %>
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div style="width: 35px; height: 35px; border-radius: 8px; background: rgba(245,158,11,0.1); color: #f59e0b; display: flex; align-items: center; justify-content: center;"><i class="fa-solid fa-id-card"></i></div>
                                    <div>
                                        <div style="font-size: 0.75rem; color: var(--text-light); text-transform: uppercase; font-weight: 600;">Citizenship No</div>
                                        <div style="font-weight: 500; color: var(--text-main); font-family: monospace; font-size: 1rem;"><%= u.getCitizenshipNo() %></div>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>

                        <!-- Display Preference Settings Card -->
                        <div class="data-table-container" style="padding: 30px; background: var(--white); border-radius: 16px;">
                            <h4 style="margin-bottom: 5px; color: var(--primary); font-size: 1.2rem; font-weight: 700; display: flex; align-items: center; gap: 8px;">
                                <i class="fa-solid fa-circle-half-stroke"></i> Display Preferences
                            </h4>
                            <p style="color: var(--text-light); margin-bottom: 20px; font-size: 0.85rem;">Choose a mode that is comfortable for your eyes.</p>
                            
                            <form action="<%= request.getContextPath() %>/user/profile/theme" method="POST" style="margin: 0;">
                                <div class="toggle-container" style="display: flex; align-items: center; justify-content: space-between; background: rgba(30, 58, 138, 0.02); padding: 15px 20px; border-radius: 12px; border: 1px solid var(--glass-border);">
                                    <div>
                                        <h5 style="font-weight: 700; font-size: 0.95rem; color: var(--text-main); margin: 0;">Premium Dark Mode</h5>
                                        <p style="font-size: 0.75rem; color: var(--text-light); margin-top: 3px; margin-bottom: 0;">Switch display modes</p>
                                    </div>
                                    <label class="switch" style="margin: 0;">
                                        <%
                                            String userTheme = (String) session.getAttribute("userThemeMode");
                                            if (userTheme == null) {
                                                userTheme = (String) application.getAttribute("sys_themeMode");
                                            }
                                        %>
                                        <input type="checkbox" name="themeMode" value="dark" <%= "dark".equals(userTheme) ? "checked" : "" %> onchange="this.form.submit()">
                                        <span class="slider"></span>
                                    </label>
                                </div>
                            </form>
                        </div>

                    </div>

                    <!-- Verification Form Container -->
                    <div class="data-table-container" style="padding: 40px; background: var(--white);">
                        <h3 style="margin-bottom: 10px; color: var(--primary); font-size: 1.5rem; font-weight: 700;">Identity Verification</h3>
                        <p style="color: var(--text-light); margin-bottom: 30px; font-size: 0.95rem;">Upload valid documents to verify your identity and unlock grievance lodging capabilities.</p>
                        
                        <% 
                            String error = (String) session.getAttribute("error");
                            if (error != null) {
                        %>
                            <div class="message message-error" style="background: rgba(239, 68, 68, 0.1); color: var(--secondary); padding: 15px; border-radius: 8px; margin-bottom: 25px;"><i class="fa-solid fa-circle-exclamation" style="margin-right: 8px;"></i> <%= error %></div>
                        <% session.removeAttribute("error"); } %>
                        
                        <% 
                            String success = (String) session.getAttribute("success");
                            if (success != null) {
                        %>
                            <div class="message message-success" style="background: rgba(16, 185, 129, 0.1); color: #059669; padding: 15px; border-radius: 8px; margin-bottom: 25px;"><i class="fa-solid fa-circle-check" style="margin-right: 8px;"></i> <%= success %></div>
                        <% session.removeAttribute("success"); } %>

                        <style>
                            .custom-file-upload {
                                display: flex;
                                flex-direction: column;
                                align-items: center;
                                justify-content: center;
                                border: 2px dashed #cbd5e1;
                                border-radius: 12px;
                                padding: 25px 20px;
                                background: #f8fafc;
                                cursor: pointer;
                                transition: all 0.3s ease;
                                text-align: center;
                            }
                            .custom-file-upload:hover {
                                border-color: var(--primary-light);
                                background: rgba(59,130,246,0.02);
                            }
                            .custom-file-upload i {
                                font-size: 2.2rem;
                                color: var(--primary-light);
                                margin-bottom: 12px;
                            }
                            .custom-file-upload span {
                                color: var(--text-main);
                                font-weight: 500;
                            }
                            .custom-file-upload small {
                                color: var(--text-light);
                                margin-top: 5px;
                            }
                            input[type="file"] {
                                display: none;
                            }
                            /* Toggle switch styling */
                            .switch {
                                position: relative;
                                display: inline-block;
                                width: 44px;
                                height: 24px;
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
                                background-color: #cbd5e1;
                                transition: .3s cubic-bezier(0.4, 0, 0.2, 1);
                                border-radius: 24px;
                            }

                            .slider:before {
                                position: absolute;
                                content: "";
                                height: 18px;
                                width: 18px;
                                left: 3px;
                                bottom: 3px;
                                background-color: white;
                                transition: .3s cubic-bezier(0.4, 0, 0.2, 1);
                                border-radius: 50%;
                            }

                            input:checked + .slider {
                                background-color: var(--primary);
                            }

                            input:checked + .slider:before {
                                transform: translateX(20px);
                            }
                        </style>

                        <% if("Unverified".equals(vStatus)) { %>
                        <form action="<%= request.getContextPath() %>/user/profile/update" method="POST" enctype="multipart/form-data">
                            
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-bottom: 25px;">
                                <div class="form-group">
                                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: var(--text-main);">Citizenship Number <span style="color: var(--secondary);">*</span></label>
                                    <input type="text" name="citizenshipNo" placeholder="e.g. 27-01-79-12345" required style="width: 100%; padding: 14px; border-radius: 10px; border: 1px solid #e2e8f0; background: #f8fafc; outline: none; font-size: 1rem; transition: all 0.3s;" onfocus="this.style.borderColor='var(--primary-light)'; this.style.boxShadow='0 0 0 3px rgba(59,130,246,0.1)'" onblur="this.style.borderColor='#e2e8f0'; this.style.boxShadow='none'">
                                </div>
                            </div>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-bottom: 30px;">
                                <div class="form-group">
                                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: var(--text-main);">Profile Avatar <span style="color: var(--secondary);">*</span></label>
                                    <label class="custom-file-upload">
                                        <input type="file" name="avatar" accept="image/*" required onchange="this.nextElementSibling.nextElementSibling.innerText = this.files[0].name">
                                        <i class="fa-solid fa-cloud-arrow-up"></i>
                                        <span>Click to browse</span>
                                        <small>PNG, JPG up to 5MB</small>
                                    </label>
                                </div>

                                <div class="form-group">
                                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: var(--text-main);">Citizenship Card Photo <span style="color: var(--secondary);">*</span></label>
                                    <label class="custom-file-upload">
                                        <input type="file" name="citizenshipPhoto" accept="image/*" required onchange="this.nextElementSibling.nextElementSibling.innerText = this.files[0].name">
                                        <i class="fa-regular fa-id-card"></i>
                                        <span>Click to browse</span>
                                        <small>Clear photo of front & back</small>
                                    </label>
                                </div>
                            </div>

                            <button type="submit" style="background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%); color: white; border: none; padding: 15px 30px; border-radius: 12px; font-weight: 700; cursor: pointer; transition: all 0.3s; width: 100%; font-size: 1.1rem; box-shadow: 0 10px 20px rgba(59, 130, 246, 0.25);" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform='translateY(0)'">
                                <i class="fa-solid fa-shield-check" style="margin-right: 8px;"></i> Submit for Verification
                            </button>
                        </form>
                        <% } else if ("Pending".equals(vStatus)) { %>
                            <div style="background: rgba(59, 130, 246, 0.05); border: 1px solid rgba(59, 130, 246, 0.2); padding: 40px 30px; border-radius: 16px; text-align: center;">
                                <div style="width: 80px; height: 80px; background: rgba(59, 130, 246, 0.1); color: #3b82f6; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; margin: 0 auto 20px;">
                                    <i class="fa-solid fa-hourglass-half fa-spin-pulse"></i>
                                </div>
                                <h3 style="color: var(--primary); margin-bottom: 12px; font-size: 1.4rem;">Verification in Progress</h3>
                                <p style="color: var(--text-light); line-height: 1.7; font-size: 1.05rem; max-width: 400px; margin: 0 auto;">Your identity documents have been securely transmitted and are currently being reviewed by government authorities. You will be notified once approved.</p>
                            </div>
                        <% } else { %>
                            <div style="background: rgba(16, 185, 129, 0.05); border: 1px solid rgba(16, 185, 129, 0.2); padding: 40px 30px; border-radius: 16px; text-align: center;">
                                <div style="width: 80px; height: 80px; background: rgba(16, 185, 129, 0.1); color: #10b981; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; margin: 0 auto 20px;">
                                    <i class="fa-solid fa-shield-check"></i>
                                </div>
                                <h3 style="color: #059669; margin-bottom: 12px; font-size: 1.4rem;">Fully Verified Citizen</h3>
                                <p style="color: var(--text-light); line-height: 1.7; font-size: 1.05rem; max-width: 400px; margin: 0 auto;">Your identity has been successfully verified. You have full, unrestricted access to lodge and track grievances in the portal.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
