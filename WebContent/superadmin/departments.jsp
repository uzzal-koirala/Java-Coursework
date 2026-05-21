<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, model.User, model.Department, service.SuperAdminService, dao.GunasoDAO" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || !"SUPER_ADMIN".equals(sessionUser.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    SuperAdminService adminService = new SuperAdminService();
    GunasoDAO gunasoDAO = new GunasoDAO();

    List<Department> departments = gunasoDAO.getAllDepartments();
    Map<Integer, Integer> officerCounts = adminService.getDepartmentOfficerCounts();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Departments - Gunaso Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <% 
        String sysTheme = (String) application.getAttribute("sys_themeMode");
        if ("dark".equals(sysTheme)) { 
    %>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin-dark.css">
    <% } %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap">
    <style>
        .split-layout {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 40px;
        }

        @media (max-width: 992px) {
            .split-layout {
                grid-template-columns: 1fr;
            }
        }

        /* Forms and Cards */
        .action-card {
            background: var(--glass-bg) !important;
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border) !important;
            border-radius: 24px !important;
            padding: 30px !important;
            box-shadow: var(--glass-shadow) !important;
            height: fit-content;
        }

        .form-group-dept {
            margin-bottom: 25px;
        }

        .form-group-dept label {
            display: block;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-light) !important;
            margin-bottom: 10px;
        }

        .form-group-dept input {
            width: 100%;
            padding: 14px 20px;
            border-radius: 12px;
            background: var(--white) !important;
            border: 1px solid var(--glass-border) !important;
            outline: none;
            font-size: 1rem;
            color: var(--text-main) !important;
            transition: all 0.3s ease;
        }

        .form-group-dept input:focus {
            border-color: var(--primary-light) !important;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15) !important;
        }

        .btn-dept-save {
            background: linear-gradient(135deg, #10b981, #059669) !important;
            color: white;
            border: none;
            padding: 14px 25px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            width: 100%;
            transition: all 0.3s ease;
            box-shadow: 0 10px 20px rgba(16, 185, 129, 0.15);
        }

        .btn-dept-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 25px rgba(16, 185, 129, 0.25);
        }

        /* Table Enhanced */
        .data-table-container {
            background: var(--glass-bg) !important;
            border: 1px solid var(--glass-border) !important;
            border-radius: 24px !important;
            box-shadow: var(--glass-shadow) !important;
            overflow: hidden;
        }
        
        .data-table th { 
            background: rgba(30, 41, 59, 0.05); 
            color: var(--text-light) !important; 
            border-bottom: 1px solid var(--glass-border) !important; 
            font-size: 0.85rem !important; 
            text-transform: uppercase;
            letter-spacing: 1px !important; 
            padding: 20px 25px !important;
        }
        
        body.dark-mode .data-table th {
            background: rgba(15, 23, 42, 0.3);
        }

        .data-table td { 
            color: var(--text-main) !important; 
            border-bottom: 1px solid var(--glass-border) !important; 
            padding: 20px 25px !important;
            font-size: 0.95rem !important;
        }
        .data-table tbody tr:hover { background: rgba(30, 41, 59, 0.02); }
        body.dark-mode .data-table tbody tr:hover { background: rgba(255, 255, 255, 0.02); }
        .id-col { font-family: 'Share Tech Mono', monospace; color: var(--text-light) !important; }
        .title-col { color: var(--text-main) !important; }

        /* Modal styling */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(8px);
            z-index: 1000;
            display: flex;
            justify-content: center;
            align-items: center;
            opacity: 0;
            pointer-events: none;
            transition: all 0.3s ease;
        }

        .modal-overlay.active {
            opacity: 1;
            pointer-events: auto;
        }

        .modal-content-card {
            background: var(--white) !important;
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            transform: scale(0.9);
            transition: all 0.3s ease;
        }

        .modal-overlay.active .modal-content-card {
            transform: scale(1);
        }

        .modal-header {
            background: rgba(30, 41, 59, 0.03) !important;
            color: var(--text-main) !important;
            padding: 25px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--glass-border) !important;
        }

        .modal-close-btn {
            background: rgba(30, 41, 59, 0.05);
            border: 1px solid var(--glass-border);
            color: var(--text-light);
            width: 35px; height: 35px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .modal-close-btn:hover { background: rgba(239,68,68,0.2); color: #ef4444; border-color: rgba(239,68,68,0.5); }

        .modal-body {
            padding: 30px;
        }

        .modal-footer {
            padding: 20px 30px;
            background: rgba(30, 41, 59, 0.02) !important;
            border-top: 1px solid var(--glass-border) !important;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }

        .btn-cancel {
            background: rgba(30, 41, 59, 0.05); color: var(--text-main); border: 1px solid var(--glass-border);
            padding: 12px 25px; border-radius: 12px; font-weight: 600; cursor: pointer; transition: all 0.3s;
        }
        .btn-cancel:hover { background: rgba(30, 41, 59, 0.1); }

        .btn-save {
            background: #10b981; color: #fff; border: none;
            padding: 12px 25px; border-radius: 12px; font-weight: 600; cursor: pointer; transition: all 0.3s;
        }
        .btn-save:hover { background: #059669; }

        footer { background: transparent !important; border-top: 1px solid var(--glass-border) !important; }
        .section-header h2 { color: var(--text-main) !important; font-size: 2rem !important; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <jsp:include page="/components/sidebar.jsp" />
        
        <div class="main-content">
            <jsp:include page="/components/navbar.jsp" />
            
            <div class="dashboard-body">
                <div class="section-header">
                    <h2>Manage Departments</h2>
                </div>

                <!-- Alerts -->
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

                <div class="split-layout">
                    <!-- Left: Add Form -->
                    <div class="action-card">
                        <h3 style="font-weight: 700; margin-bottom: 20px; font-size: 1.1rem; color: var(--primary);">Add Department</h3>
                        <form action="<%= request.getContextPath() %>/superadmin/action" method="POST">
                            <input type="hidden" name="action" value="addDept">
                            
                            <div class="form-group-dept">
                                <label for="deptName">Department Name</label>
                                <input type="text" id="deptName" name="deptName" placeholder="e.g. Infrastructure Development" required>
                            </div>
                            
                            <button type="submit" class="btn-dept-save">
                                <i class="fa-solid fa-plus" style="margin-right: 5px;"></i> Add Department
                            </button>
                        </form>
                    </div>

                    <!-- Right: Grid Table -->
                    <div class="data-table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Department Name</th>
                                    <th>Assigned Officers</th>
                                    <th>Clearance Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    if (departments != null && !departments.isEmpty()) {
                                        for (Department d : departments) {
                                            int officers = officerCounts.getOrDefault(d.getId(), 0);
                                %>
                                    <tr>
                                        <td class="id-col">#<%= d.getId() %></td>
                                        <td class="title-col" style="font-weight: 600;"><%= d.getDeptName() %></td>
                                        <td>
                                            <span style="font-weight: 700; font-size: 0.95rem; color: #475569; background: rgba(71, 85, 105, 0.05); padding: 5px 12px; border-radius: 8px;">
                                                <%= officers %> Officers
                                            </span>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 8px;">
                                                <button class="btn-view" onclick="openEditModal(<%= d.getId() %>, '<%= d.getDeptName().replace("'", "\\'") %>')" style="padding: 6px 12px; font-size: 0.8rem; border: none; cursor: pointer;">
                                                    <i class="fa-solid fa-pen-to-square"></i> Edit
                                                </button>
                                                
                                                <form action="<%= request.getContextPath() %>/superadmin/action" method="POST" onsubmit="return confirm('Are you sure you want to delete this department? This action cannot be undone.');" style="display: inline;">
                                                    <input type="hidden" name="action" value="deleteDept">
                                                    <input type="hidden" name="deptId" value="<%= d.getId() %>">
                                                    <button type="submit" class="btn-view" style="color: #ef4444; background: rgba(239, 68, 68, 0.05); padding: 6px 12px; font-size: 0.8rem; border: none; cursor: pointer;">
                                                        <i class="fa-solid fa-trash"></i> Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% 
                                        }
                                    } else {
                                %>
                                    <tr>
                                        <td colspan="4" style="text-align: center; padding: 30px; color: #7f8c8d;">No departments created yet.</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
</div>
    </div>

    <!-- Edit Department Modal -->
    <div class="modal-overlay" id="editModal">
        <div class="modal-content-card">
            <div class="modal-header">
                <h3 style="font-weight: 700;">Edit Department</h3>
                <button class="modal-close-btn" onclick="closeEditModal()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/superadmin/action" method="POST">
                <input type="hidden" name="action" value="editDept">
                <input type="hidden" name="deptId" id="editDeptId">
                
                <div class="modal-body">
                    <div class="form-group-dept">
                        <label for="editDeptName">Department Name</label>
                        <input type="text" id="editDeptName" name="deptName" required>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeEditModal()">Cancel</button>
                    <button type="submit" class="btn-save">Apply Changes</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openEditModal(id, name) {
            document.getElementById('editDeptId').value = id;
            document.getElementById('editDeptName').value = name;
            document.getElementById('editModal').classList.add('active');
        }

        function closeEditModal() {
            document.getElementById('editModal').classList.remove('active');
        }
    </script>
</body>
</html>
