<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Department" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Gunaso - Gunaso Portal</title>
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
                    <h1>Lodge Grievance</h1>
                    <p>Submit a new complaint to government authorities</p>
                </div>
            </div>
            
            <div class="dashboard-body">
                <% 
                    model.User u = (model.User) session.getAttribute("user");
                    String vStatus = u != null ? u.getVerificationStatus() : "Unverified";
                    if ("Verified".equals(vStatus)) {
                %>
                <div class="data-table-container" style="max-width: 800px; margin: 0 auto; padding: 30px;">
                    <h2 style="margin-bottom: 20px; color: var(--primary);">Submit New Complaint (Gunaso)</h2>
                    
                    <% 
                        String error = (String) session.getAttribute("error");
                        if (error != null) {
                    %>
                        <div class="message message-error" style="background: rgba(239, 68, 68, 0.1); color: var(--secondary); padding: 15px; border-radius: 8px; margin-bottom: 20px;"><%= error %></div>
                    <% 
                            session.removeAttribute("error");
                        }
                    %>

                    <form action="<%= request.getContextPath() %>/gunaso/submit" method="POST" enctype="multipart/form-data">
                        <div class="form-group" style="margin-bottom: 20px;">
                            <label for="title" style="display: block; margin-bottom: 8px; font-weight: 500;">Title / Subject</label>
                            <input type="text" id="title" name="title" placeholder="Brief subject of your issue" required style="width: 100%; padding: 12px; border-radius: 10px; border: 1px solid #e2e8f0; background: #f8fafc; outline: none;">
                        </div>
                        
                        <div class="form-group" style="margin-bottom: 20px;">
                            <label for="deptId" style="display: block; margin-bottom: 8px; font-weight: 500;">Department</label>
                            <select id="deptId" name="deptId" required style="width: 100%; padding: 12px; border-radius: 10px; border: 1px solid #e2e8f0; background: #f8fafc; outline: none;">
                                <option value="">Select Department</option>
                                <% 
                                    List<Department> depts = (List<Department>) request.getAttribute("departments");
                                    if (depts != null) {
                                        for (Department d : depts) {
                                %>
                                    <option value="<%= d.getId() %>"><%= d.getDeptName() %></option>
                                <% 
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group" style="margin-bottom: 20px;">
                            <label for="description" style="display: block; margin-bottom: 8px; font-weight: 500;">Detailed Description</label>
                            <textarea id="description" name="description" rows="6" placeholder="Explain your issue in detail..." required style="width: 100%; padding: 12px; border-radius: 10px; border: 1px solid #e2e8f0; background: #f8fafc; outline: none;"></textarea>
                        </div>

                        <div class="form-group" style="margin-bottom: 25px;">
                            <label for="attachment" style="display: block; margin-bottom: 8px; font-weight: 500;">Attachment (Optional)</label>
                            <input type="file" id="attachment" name="attachment" style="width: 100%; padding: 10px; border: 1px dashed #cbd5e1; border-radius: 10px; background: #f8fafc;">
                        </div>

                        <button type="submit" style="background: var(--primary); color: white; border: none; padding: 12px 25px; border-radius: 10px; font-weight: 600; cursor: pointer; transition: all 0.3s;">Submit Gunaso</button>
                    </form>
                </div>
                <% } else { %>
                    <div style="max-width: 600px; margin: 40px auto; background: var(--glass-bg); backdrop-filter: blur(20px); border: 1px solid var(--glass-border); border-radius: 20px; padding: 40px; text-align: center; box-shadow: var(--glass-shadow);">
                        <div style="width: 80px; height: 80px; background: rgba(245, 158, 11, 0.1); color: #f59e0b; font-size: 2.5rem; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                            <i class="fa-solid fa-shield-halved"></i>
                        </div>
                        <h2 style="color: var(--primary); margin-bottom: 15px; font-size: 1.8rem;">Verification Required</h2>
                        <p style="color: var(--text-light); margin-bottom: 30px; line-height: 1.6;">
                            To ensure the authenticity of grievances, you must verify your identity before lodging a complaint. Please upload your citizenship details in the Settings page and wait for authority approval.
                        </p>
                        <a href="<%= request.getContextPath() %>/user/profile.jsp" style="display: inline-flex; align-items: center; gap: 10px; background: var(--primary); color: white; text-decoration: none; padding: 12px 25px; border-radius: 100px; font-weight: 600; transition: all 0.3s;">
                            <i class="fa-solid fa-user-gear"></i> Go to Settings
                        </a>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>
