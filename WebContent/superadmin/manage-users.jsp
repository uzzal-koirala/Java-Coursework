<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.User, model.Department, service.SuperAdminService, dao.GunasoDAO" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || !"SUPER_ADMIN".equals(sessionUser.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    SuperAdminService adminService = new SuperAdminService();
    GunasoDAO gunasoDAO = new GunasoDAO();

    List<User> users = adminService.getAllUsers();
    List<Department> departments = gunasoDAO.getAllDepartments();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Gunaso Portal</title>
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
        .filter-bar {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: var(--glass-shadow);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-group select, .filter-group input {
            padding: 10px 15px;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            background: #ffffff;
            outline: none;
            font-size: 0.9rem;
            color: var(--text-main);
            transition: all 0.3s ease;
        }

        .filter-group select:focus, .filter-group input:focus {
            border-color: var(--primary-light);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }

        .badge-status {
            padding: 6px 12px;
            border-radius: 100px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .badge-active { background: rgba(16, 185, 129, 0.1); color: #10b981; }
        .badge-deactivated { background: rgba(239, 68, 68, 0.1); color: #ef4444; }

        /* Modal Overlay styling */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.55);
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
            background: #ffffff;
            border-radius: 20px;
            width: 100%;
            max-width: 550px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            transform: scale(0.9);
            transition: all 0.3s ease;
        }

        .modal-overlay.active .modal-content-card {
            transform: scale(1);
        }

        .modal-header {
            background: var(--primary);
            color: #ffffff;
            padding: 20px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h3 {
            font-weight: 700;
            font-size: 1.2rem;
        }

        .modal-close-btn {
            background: none;
            border: none;
            color: #ffffff;
            font-size: 1.2rem;
            cursor: pointer;
            opacity: 0.8;
            transition: all 0.3s ease;
        }

        .modal-close-btn:hover {
            opacity: 1;
            transform: scale(1.1);
        }

        .modal-body {
            padding: 25px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .modal-form-group {
            margin-bottom: 20px;
        }

        .modal-form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-light);
            margin-bottom: 8px;
        }

        .modal-form-group input, .modal-form-group select {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            outline: none;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .modal-form-group input:focus, .modal-form-group select:focus {
            border-color: var(--primary-light);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }

        .modal-footer {
            padding: 20px 25px;
            border-top: 1px solid #f1f5f9;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-cancel {
            background: #cbd5e1;
            color: #475569;
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-cancel:hover { background: #94a3b8; }

        .btn-save {
            background: var(--primary-light);
            color: #ffffff;
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(59, 130, 246, 0.2);
            transition: all 0.3s ease;
        }

        .btn-save:hover {
            background: var(--primary);
            box-shadow: 0 6px 15px rgba(30, 58, 138, 0.2);
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
                    <h2>Manage Users</h2>
                    <button class="hero-actions btn-lodge" onclick="openCreateModal()" style="background: var(--primary-light); border: none; font-size: 0.9rem; cursor: pointer; padding: 10px 20px; border-radius: 8px;">
                        <i class="fa-solid fa-user-plus"></i> Create Official Account
                    </button>
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

                <!-- Filter Bar -->
                <div class="filter-bar">
                    <div class="filter-group">
                        <i class="fa-solid fa-magnifying-glass" style="color: var(--text-light);"></i>
                        <input type="text" id="userSearch" onkeyup="filterUsers()" placeholder="Search users by name, email...">
                    </div>
                    <div class="filter-group">
                        <label for="roleFilter">Role:</label>
                        <select id="roleFilter" onchange="filterUsers()">
                            <option value="ALL">All Roles</option>
                            <option value="CITIZEN">Citizen</option>
                            <option value="WADA_ADAKSHYA">Wada Adakshya</option>
                            <option value="NAGAR_PRAMUKH">Nagar Pramukh</option>
                            <option value="PRIME_MINISTER">Prime Minister</option>
                            <option value="SUPER_ADMIN">Super Admin</option>
                        </select>

                        <label for="statusFilter" style="margin-left: 15px;">Status:</label>
                        <select id="statusFilter" onchange="filterUsers()">
                            <option value="ALL">All Statuses</option>
                            <option value="ACTIVE">Active</option>
                            <option value="DEACTIVATED">Deactivated</option>
                        </select>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="data-table-container">
                    <table class="data-table" id="usersTable">
                        <thead>
                            <tr>
                                <th>User Profile</th>
                                <th>Contact Information</th>
                                <th>System Role</th>
                                <th>Assigned Department</th>
                                <th>Status</th>
                                <th>Clearance Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (users != null && !users.isEmpty()) {
                                    for (User u : users) {
                                        String initials = "DU";
                                        if (u.getFullName() != null && !u.getFullName().isEmpty()) {
                                            String[] parts = u.getFullName().split(" ");
                                            if (parts.length > 1) {
                                                initials = parts[0].substring(0, 1) + parts[1].substring(0, 1);
                                            } else {
                                                initials = u.getFullName().substring(0, Math.min(2, u.getFullName().length())).toUpperCase();
                                            }
                                        }
                            %>
                                <tr class="user-row" data-role="<%= u.getRoleName() %>" data-status="<%= u.getStatus().toUpperCase() %>" data-name="<%= u.getFullName().toLowerCase() %>" data-email="<%= u.getEmail().toLowerCase() %>">
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 15px;">
                                            <% if (u.getAvatar() != null && !u.getAvatar().isEmpty()) { %>
                                                <div class="profile-avatar" style="background-image: url('<%= request.getContextPath() %>/<%= u.getAvatar() %>'); background-size: cover; background-position: center; box-shadow: none; color: transparent; width: 40px; height: 40px;"></div>
                                            <% } else { %>
                                                <div class="profile-avatar" style="width: 40px; height: 40px; font-size: 0.95rem; box-shadow: none;"><%= initials.toUpperCase() %></div>
                                            <% } %>
                                            <div>
                                                <h4 style="font-weight: 600; font-size: 0.95rem;"><%= u.getFullName() %></h4>
                                                <span style="font-size: 0.8rem; color: var(--text-light);">ID: #<%= u.getId() %></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="font-size: 0.9rem;">
                                            <div><i class="fa-regular fa-envelope" style="color: var(--text-light); width: 18px;"></i> <%= u.getEmail() %></div>
                                            <div style="margin-top: 4px; color: var(--text-light);"><i class="fa-solid fa-phone" style="width: 18px;"></i> <%= u.getPhone() %></div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge" style="background: rgba(30, 58, 138, 0.05); color: var(--primary); font-size: 0.75rem; border: 1px solid rgba(30, 58, 138, 0.1);">
                                            <%= u.getRoleName() %>
                                        </span>
                                    </td>
                                    <td>
                                        <span style="font-size: 0.9rem; font-weight: 500; color: #475569;">
                                            <%= u.getDeptName() != null ? u.getDeptName() : "—" %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge-status badge-<%= u.getStatus().toLowerCase() %>">
                                            <%= u.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 8px;">
                                            <button class="btn-view" onclick="openEditModal(<%= u.getId() %>, '<%= u.getFullName() %>', <%= u.getRoleId() %>, <%= u.getDeptId() != null ? u.getDeptId() : -1 %>)" style="padding: 6px 12px; font-size: 0.8rem; cursor: pointer; border: none;">
                                                <i class="fa-solid fa-user-pen"></i> Edit
                                            </button>
                                            
                                            <% if (u.getId() != sessionUser.getId()) { %>
                                                <form action="<%= request.getContextPath() %>/superadmin/action" method="POST" style="display: inline;">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="userId" value="<%= u.getId() %>">
                                                    
                                                    <% if ("Active".equals(u.getStatus())) { %>
                                                        <input type="hidden" name="status" value="Deactivated">
                                                        <button type="submit" class="btn-view" style="color: #ef4444; background: rgba(239, 68, 68, 0.05); padding: 6px 12px; font-size: 0.8rem; border: none; cursor: pointer;">
                                                            <i class="fa-solid fa-user-slash"></i> Block
                                                        </button>
                                                    <% } else { %>
                                                        <input type="hidden" name="status" value="Active">
                                                        <button type="submit" class="btn-view" style="color: #10b981; background: rgba(16, 185, 129, 0.05); padding: 6px 12px; font-size: 0.8rem; border: none; cursor: pointer;">
                                                            <i class="fa-solid fa-user-check"></i> Unblock
                                                        </button>
                                                    <% } %>
                                                </form>

                                                <form action="<%= request.getContextPath() %>/superadmin/action" method="POST" style="display: inline;" onsubmit="return confirm('Are you sure to permanently delete the user?');">
                                                    <input type="hidden" name="action" value="deleteUser">
                                                    <input type="hidden" name="userId" value="<%= u.getId() %>">
                                                    <button type="submit" class="btn-view" style="color: #ef4444; background: rgba(239, 68, 68, 0.1); padding: 6px 12px; font-size: 0.8rem; border: none; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.background='rgba(239, 68, 68, 0.2)'" onmouseout="this.style.background='rgba(239, 68, 68, 0.1)'">
                                                        <i class="fa-solid fa-trash"></i> Delete
                                                    </button>
                                                </form>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 30px; color: #7f8c8d;">No users found in system.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <jsp:include page="/components/footer.jsp" />
        </div>
    </div>

    <!-- MODAL 1: Create Official User -->
    <div class="modal-overlay" id="createModal">
        <div class="modal-content-card">
            <div class="modal-header">
                <h3>Create Official Account</h3>
                <button class="modal-close-btn" onclick="closeCreateModal()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/superadmin/action" method="POST">
                <input type="hidden" name="action" value="createOfficial">
                
                <div class="modal-body">
                    <div class="modal-form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" placeholder="e.g. Balen Shah" required>
                    </div>

                    <div class="form-row">
                        <div class="modal-form-group">
                            <label for="email">Clearance Email</label>
                            <input type="email" id="email" name="email" placeholder="balen@gunaso.gov.np" required>
                        </div>
                        <div class="modal-form-group">
                            <label for="phone">Phone Number</label>
                            <input type="text" id="phone" name="phone" placeholder="98XXXXXXXX" required>
                        </div>
                    </div>

                    <div class="modal-form-group">
                        <label for="password">Initial Password</label>
                        <input type="password" id="password" name="password" placeholder="••••••••" required>
                    </div>

                    <div class="form-row">
                        <div class="modal-form-group">
                            <label for="roleId">Clearance Role</label>
                            <select id="roleId" name="roleId" onchange="toggleDeptDropdown('roleId', 'deptDropdownGroup')" required>
                                <option value="2">Wada Adakshya</option>
                                <option value="3">Nagar Pramukh</option>
                                <option value="4">Prime Minister</option>
                                <option value="5">Super Admin</option>
                            </select>
                        </div>
                        <div class="modal-form-group" id="deptDropdownGroup">
                            <label for="deptId">Assigned Department</label>
                            <select id="deptId" name="deptId">
                                <option value="-1">None (Universal/No Dept)</option>
                                <% for (Department d : departments) { %>
                                    <option value="<%= d.getId() %>"><%= d.getDeptName() %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeCreateModal()">Cancel</button>
                    <button type="submit" class="btn-save">Register Credentials</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 2: Edit User Role / Dept -->
    <div class="modal-overlay" id="editModal">
        <div class="modal-content-card">
            <div class="modal-header">
                <h3>Edit Clearance Credentials</h3>
                <button class="modal-close-btn" onclick="closeEditModal()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/superadmin/action" method="POST">
                <input type="hidden" name="action" value="updateRoleDept">
                <input type="hidden" name="userId" id="editUserId">
                
                <div class="modal-body">
                    <div class="modal-form-group">
                        <label>User Profile</label>
                        <input type="text" id="editUserName" readonly style="background: #f1f5f9; color: #64748b; font-weight: 600;">
                    </div>

                    <div class="form-row">
                        <div class="modal-form-group">
                            <label for="editRoleId">Security Role</label>
                            <select id="editRoleId" name="roleId" onchange="toggleDeptDropdown('editRoleId', 'editDeptDropdownGroup')" required>
                                <option value="1">Citizen</option>
                                <option value="2">Wada Adakshya</option>
                                <option value="3">Nagar Pramukh</option>
                                <option value="4">Prime Minister</option>
                                <option value="5">Super Admin</option>
                            </select>
                        </div>
                        <div class="modal-form-group" id="editDeptDropdownGroup">
                            <label for="editDeptId">Assigned Department</label>
                            <select id="editDeptId" name="deptId">
                                <option value="">None (Universal/No Dept)</option>
                                <% for (Department d : departments) { %>
                                    <option value="<%= d.getId() %>"><%= d.getDeptName() %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeEditModal()">Cancel</button>
                    <button type="submit" class="btn-save">Apply Credentials</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Modal management
        function openCreateModal() {
            document.getElementById('createModal').classList.add('active');
        }
        function closeCreateModal() {
            document.getElementById('createModal').classList.remove('active');
        }

        function openEditModal(userId, fullName, roleId, deptId) {
            document.getElementById('editUserId').value = userId;
            document.getElementById('editUserName').value = fullName;
            document.getElementById('editRoleId').value = roleId;
            
            const deptSelect = document.getElementById('editDeptId');
            if (deptId === -1 || !deptId) {
                deptSelect.value = "";
            } else {
                deptSelect.value = deptId;
            }

            // Trigger dropdown display
            toggleDeptDropdown('editRoleId', 'editDeptDropdownGroup');

            document.getElementById('editModal').classList.add('active');
        }

        function closeEditModal() {
            document.getElementById('editModal').classList.remove('active');
        }

        // Hide/Show department dropdown depending on role
        function toggleDeptDropdown(roleSelectId, deptGroupId) {
            const roleVal = document.getElementById(roleSelectId).value;
            const deptGroup = document.getElementById(deptGroupId);
            
            // Only Wada Adakshya (2) and Nagar Pramukh (3) need departments
            if (roleVal === "2" || roleVal === "3") {
                deptGroup.style.display = "block";
            } else {
                deptGroup.style.display = "none";
            }
        }

        // Live Filtering
        function filterUsers() {
            const searchQuery = document.getElementById('userSearch').value.toLowerCase();
            const roleFilter = document.getElementById('roleFilter').value;
            const statusFilter = document.getElementById('statusFilter').value;
            const rows = document.querySelectorAll('.user-row');

            rows.forEach(row => {
                const name = row.getAttribute('data-name');
                const email = row.getAttribute('data-email');
                const role = row.getAttribute('data-role');
                const status = row.getAttribute('data-status');

                const matchesSearch = name.includes(searchQuery) || email.includes(searchQuery);
                const matchesRole = (roleFilter === "ALL" || role === roleFilter);
                const matchesStatus = (statusFilter === "ALL" || status === statusFilter);

                if (matchesSearch && matchesRole && matchesStatus) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }
    </script>
</body>
</html>
