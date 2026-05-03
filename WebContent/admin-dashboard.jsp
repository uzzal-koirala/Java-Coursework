<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.merosarkar.model.Complaint" %>
<%@ page import="com.merosarkar.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || "CITIZEN".equals(currentUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    List<User> users = (List<User>) request.getAttribute("users");
    
    if (complaints == null || users == null) {
        response.sendRedirect("AdminComplaintServlet");
        return;
    }
    
    String currentSection = request.getParameter("section");
    if (currentSection == null) currentSection = "complaints";
    
    int totalComplaints = (complaints != null) ? complaints.size() : 0;
    int pendingComplaints = 0;
    if (complaints != null) {
        for (Complaint c : complaints) if ("PENDING".equals(c.getStatus())) pendingComplaints++;
    }
    int totalUsers = (users != null) ? users.size() : 0;
%>
<!DOCTYPE html>
<html lang="ne">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>प्रशासनिक ड्यासबोर्ड | मेरो सरकार</title>
    
    <!-- Premium Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&family=Inter:wght@400;600;700&family=Mukta:wght@400;600;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/admin-styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="admin-body">

    <div class="admin-layout">
        <!-- Sidebar -->
        <aside class="admin-sidebar">
            <div class="sidebar-logo">
                <img src="images/logo.png" alt="Logo">
                <h2>मेरो सरकार</h2>
            </div>
            
            <nav class="sidebar-nav">
                <a href="AdminComplaintServlet?section=complaints" class="sidebar-link <%= "complaints".equals(currentSection) ? "active" : "" %>">
                    <i class="fas fa-clipboard-list"></i> <span>गुनासोहरू</span>
                </a>
                <a href="AdminComplaintServlet?section=users" class="sidebar-link <%= "users".equals(currentSection) ? "active" : "" %>">
                    <i class="fas fa-users"></i> <span>प्रयोगकर्ताहरू</span>
                </a>
                <a href="AdminComplaintServlet?section=analysis" class="sidebar-link <%= "analysis".equals(currentSection) ? "active" : "" %>">
                    <i class="fas fa-chart-pie"></i> <span>विश्लेषण</span>
                </a>
                <a href="AdminComplaintServlet?section=settings" class="sidebar-link <%= "settings".equals(currentSection) ? "active" : "" %>">
                    <i class="fas fa-cog"></i> <span>सेटिङहरू</span>
                </a>
                
                <div style="margin-top: auto;">
                    <a href="LogoutServlet" class="sidebar-link" style="color: var(--admin-danger);">
                        <i class="fas fa-sign-out-alt"></i> <span>लगआउट</span>
                    </a>
                </div>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="admin-main">
            <header class="admin-header">
                <div class="header-title">
                    <h1>ड्यासबोर्ड Overview</h1>
                    <p>नमस्ते <%= currentUser.getFullName() %>, आजको अपडेटहरू यहाँ छन्।</p>
                </div>
                
                <div class="admin-profile">
                    <img src="<%= (currentUser.getProfilePic() != null) ? currentUser.getProfilePic() : "images/default-avatar.png" %>" alt="Profile" style="width: 42px; height: 42px; border-radius: 50%; border: 2px solid white; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
                    <div class="profile-text">
                        <p style="font-weight: 800; margin: 0; font-size: 0.95rem;"><%= currentUser.getFullName() %></p>
                        <span style="font-size: 0.75rem; color: var(--text-muted); font-weight: 600;"><%= currentUser.getRole() %></span>
                    </div>
                </div>
            </header>

            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(14, 165, 233, 0.1); color: #0ea5e9;">
                        <i class="fas fa-file-invoice"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= totalComplaints %></h3>
                        <p>कुल गुनासो</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(217, 119, 6, 0.1); color: #d97706;">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= pendingComplaints %></h3>
                        <p>पेन्डिङ</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= totalUsers %></h3>
                        <p>कुल प्रयोगकर्ता</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(239, 68, 68, 0.1); color: #ef4444;">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <div class="stat-info">
                        <h3>98%</h3>
                        <p>सुरक्षा स्थिति</p>
                    </div>
                </div>
            </div>

            <!-- Content Area -->
            <div class="data-table-container">
                <% if ("complaints".equals(currentSection)) { %>
                    <div class="table-header">
                        <h2>गुनासो व्यवस्थापन</h2>
                        <div class="action-btns">
                            <button class="btn-submit" style="padding: 10px 20px; font-size: 0.85rem;"><i class="fas fa-file-export"></i> Export CSV</button>
                        </div>
                    </div>
                    
                    <% if(complaints == null || complaints.isEmpty()) { %>
                        <div style="text-align: center; padding: 60px;">
                            <i class="fas fa-folder-open" style="font-size: 3rem; color: #cbd5e1; margin-bottom: 20px; display: block;"></i>
                            <p style="color: var(--text-muted); font-weight: 600;">कुनै पनि गुनासो फेला परेन।</p>
                        </div>
                    <% } else { %>
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Citizen ID</th>
                                    <th>Subject</th>
                                    <th>Description</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Complaint c : complaints) { %>
                                    <tr>
                                        <td>
                                            <span style="background: #f1f5f9; padding: 5px 12px; border-radius: 8px; font-weight: 700; font-size: 0.85rem;">
                                                #<%= c.getCitizenId() %>
                                            </span>
                                        </td>
                                        <td style="font-weight: 700; color: var(--admin-sidebar-bg);"><%= c.getSubject() %></td>
                                        <td style="max-width: 250px; color: var(--text-muted); font-size: 0.85rem;">
                                            <%= c.getDescription().length() > 60 ? c.getDescription().substring(0, 60) + "..." : c.getDescription() %>
                                        </td>
                                        <td><%= c.getCreatedAt() %></td>
                                        <td>
                                            <form action="AdminComplaintServlet" method="POST">
                                                <input type="hidden" name="action" value="updateComplaint">
                                                <input type="hidden" name="id" value="<%= c.getId() %>">
                                                <input type="hidden" name="section" value="<%= currentSection %>">
                                                <select name="status" class="status-select" onchange="this.form.submit()" 
                                                    style="color: <%= "RESOLVED".equals(c.getStatus()) ? "var(--admin-success)" : ("IN_PROGRESS".equals(c.getStatus()) ? "var(--admin-warning)" : "var(--admin-danger)") %>;">
                                                    <option value="PENDING" <%= "PENDING".equals(c.getStatus()) ? "selected" : "" %>>PENDING</option>
                                                    <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(c.getStatus()) ? "selected" : "" %>>IN PROGRESS</option>
                                                    <option value="RESOLVED" <%= "RESOLVED".equals(c.getStatus()) ? "selected" : "" %>>RESOLVED</option>
                                                </select>
                                            </form>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 8px;">
                                                <form action="AdminComplaintServlet" method="POST" onsubmit="return confirm('के तपाईं मेटाउन चाहनुहुन्छ?');">
                                                    <input type="hidden" name="action" value="deleteComplaint">
                                                    <input type="hidden" name="id" value="<%= c.getId() %>">
                                                    <input type="hidden" name="section" value="<%= currentSection %>">
                                                    <button type="submit" class="action-btn btn-delete"><i class="fas fa-trash-alt"></i></button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>

                <% } else if ("users".equals(currentSection)) { %>
                    <div class="table-header">
                        <h2>प्रयोगकर्ता व्यवस्थापन</h2>
                        <button class="btn-submit" onclick="openCreateModal()" style="padding: 10px 20px; font-size: 0.85rem;">
                            <i class="fas fa-plus"></i> नयाँ प्रयोगकर्ता
                        </button>
                    </div>
                    
                    <% if(users == null || users.isEmpty()) { %>
                        <div style="text-align: center; padding: 60px;">
                            <i class="fas fa-users-slash" style="font-size: 3rem; color: #cbd5e1; margin-bottom: 20px; display: block;"></i>
                            <p style="color: var(--text-muted); font-weight: 600;">कुनै पनि प्रयोगकर्ता फेला परेन।</p>
                        </div>
                    <% } else { %>
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>User Profile</th>
                                    <th>Phone Number</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(User u : users) { %>
                                    <tr>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 15px;">
                                                <img src="<%= (u.getProfilePic() != null) ? u.getProfilePic() : "images/default-avatar.png" %>" style="width: 40px; height: 40px; border-radius: 12px; object-fit: cover; border: 2px solid #f1f5f9;">
                                                <span style="font-weight: 700; color: var(--admin-sidebar-bg);"><%= u.getFullName() %></span>
                                            </div>
                                        </td>
                                        <td><code style="background: #f1f5f9; padding: 4px 8px; border-radius: 6px; font-weight: 600;"><%= u.getPhoneNumber() %></code></td>
                                        <td>
                                            <span class="badge <%= "CITIZEN".equals(u.getRole()) ? "badge-citizen" : "badge-admin" %>">
                                                <%= u.getRole() %>
                                            </span>
                                        </td>
                                        <td>
                                            <form action="AdminComplaintServlet" method="POST">
                                                <input type="hidden" name="action" value="updateUserStatus">
                                                <input type="hidden" name="id" value="<%= u.getId() %>">
                                                <input type="hidden" name="section" value="<%= currentSection %>">
                                                <select name="status" class="status-select" onchange="this.form.submit()"
                                                    style="color: <%= "APPROVED".equals(u.getStatus()) ? "var(--admin-success)" : "var(--admin-danger)" %>;">
                                                    <option value="APPROVED" <%= "APPROVED".equals(u.getStatus()) ? "selected" : "" %>>APPROVED</option>
                                                    <option value="PENDING" <%= "PENDING".equals(u.getStatus()) ? "selected" : "" %>>PENDING</option>
                                                    <option value="BLOCKED" <%= "BLOCKED".equals(u.getStatus()) ? "selected" : "" %>>BLOCKED</option>
                                                </select>
                                            </form>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 8px;">
                                                <button class="action-btn btn-edit" onclick="openEditModal('<%= u.getId() %>', '<%= u.getFullName() %>', '<%= u.getPhoneNumber() %>', '<%= u.getRole() %>')">
                                                    <i class="fas fa-pen"></i>
                                                </button>
                                                <form action="AdminComplaintServlet" method="POST" onsubmit="return confirm('के तपाईं यो प्रयोगकर्ता हटाउन चाहनुहुन्छ?');" style="display:inline;">
                                                    <input type="hidden" name="action" value="deleteUser">
                                                    <input type="hidden" name="id" value="<%= u.getId() %>">
                                                    <input type="hidden" name="section" value="<%= currentSection %>">
                                                    <button type="submit" class="action-btn btn-delete"><i class="fas fa-trash"></i></button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>

                <% } else if ("analysis".equals(currentSection)) { %>
                    <div class="table-header">
                        <h2>डाटा विश्लेषण (Analytics)</h2>
                    </div>
                    <div class="stats-grid" style="grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));">
                        <div class="stat-card" style="flex-direction: column; align-items: flex-start; height: 350px;">
                            <h4 style="margin-bottom: 25px; font-weight: 800;">गुनासोको प्रकृति</h4>
                            <div style="display: flex; align-items: flex-end; gap: 15px; height: 200px; width: 100%; padding-bottom: 20px; border-bottom: 2px solid #f1f5f9;">
                                <div style="flex: 1; height: 80%; background: linear-gradient(180deg, #3b82f6, #1e40af); border-radius: 8px 8px 0 0; position: relative;" title="शिक्षा">
                                    <span style="position: absolute; bottom: -25px; left: 50%; transform: translateX(-50%); font-size: 0.7rem; font-weight: 700;">शिक्षा</span>
                                </div>
                                <div style="flex: 1; height: 50%; background: linear-gradient(180deg, #10b981, #059669); border-radius: 8px 8px 0 0; position: relative;" title="स्वास्थ्य">
                                    <span style="position: absolute; bottom: -25px; left: 50%; transform: translateX(-50%); font-size: 0.7rem; font-weight: 700;">स्वास्थ्य</span>
                                </div>
                                <div style="flex: 1; height: 95%; background: linear-gradient(180deg, #f59e0b, #d97706); border-radius: 8px 8px 0 0; position: relative;" title="पूर्वाधार">
                                    <span style="position: absolute; bottom: -25px; left: 50%; transform: translateX(-50%); font-size: 0.7rem; font-weight: 700;">पूर्वाधार</span>
                                </div>
                                <div style="flex: 1; height: 40%; background: linear-gradient(180deg, #ef4444, #b91c1c); border-radius: 8px 8px 0 0; position: relative;" title="अन्य">
                                    <span style="position: absolute; bottom: -25px; left: 50%; transform: translateX(-50%); font-size: 0.7rem; font-weight: 700;">अन्य</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="stat-card" style="flex-direction: column; justify-content: center; height: 350px;">
                            <h4 style="margin-bottom: 30px; font-weight: 800;">समाधान दर</h4>
                            <div style="position: relative; width: 180px; height: 180px;">
                                <svg viewBox="0 0 36 36" style="transform: rotate(-90deg);">
                                    <path d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" fill="none" stroke="#f1f5f9" stroke-width="3" />
                                    <path d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" fill="none" stroke="var(--admin-success)" stroke-width="3" stroke-dasharray="75, 100" stroke-linecap="round" />
                                </svg>
                                <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); text-align: center;">
                                    <span style="font-size: 2rem; font-weight: 800; color: var(--admin-sidebar-bg);">75%</span>
                                    <p style="font-size: 0.7rem; margin: 0; font-weight: 700; color: var(--text-muted);">समाधान</p>
                                </div>
                            </div>
                        </div>
                    </div>

                <% } else if ("settings".equals(currentSection)) { %>
                    <div class="table-header">
                        <h2>प्रोफाइल सेटिङहरू</h2>
                    </div>
                    <div style="max-width: 600px;">
                        <form action="AdminComplaintServlet" method="POST" class="admin-form">
                            <input type="hidden" name="action" value="editUser">
                            <input type="hidden" name="id" value="<%= currentUser.getId() %>">
                            <input type="hidden" name="section" value="<%= currentSection %>">
                            <div class="form-group">
                                <label>पूरा नाम</label>
                                <input type="text" name="fullName" value="<%= currentUser.getFullName() %>" required>
                            </div>
                            <div class="form-group">
                                <label>फोन नम्बर</label>
                                <input type="text" name="phoneNumber" value="<%= currentUser.getPhoneNumber() %>" required>
                            </div>
                            <div class="form-group">
                                <label>नयाँ पासवर्ड (परिवर्तन नगर्ने भए खाली छोड्नुहोस्)</label>
                                <input type="password" name="password" placeholder="********">
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn-submit">विवरण अपडेट गर्नुहोस्</button>
                            </div>
                        </form>
                    </div>
                <% } %>
            </div>
        </main>
    </div>

    <!-- Modals -->
    <div id="createUserModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h2>नयाँ प्रयोगकर्ता</h2>
                <button class="close-modal" onclick="closeModal('createUserModal')">&times;</button>
            </div>
            <form action="AdminComplaintServlet" method="POST" class="admin-form">
                <input type="hidden" name="action" value="createUser">
                <input type="hidden" name="section" value="<%= currentSection %>">
                <div class="form-group">
                    <label>पूरा नाम</label>
                    <input type="text" name="fullName" required placeholder="उदा: राम बहादुर">
                </div>
                <div class="form-group">
                    <label>फोन नम्बर</label>
                    <input type="text" name="phoneNumber" required placeholder="98XXXXXXXX">
                </div>
                <div class="form-group">
                    <label>पासवर्ड</label>
                    <input type="password" name="password" required placeholder="********">
                </div>
                <div class="form-row" style="display: flex; gap: 20px;">
                    <div class="form-group" style="flex: 1;">
                        <label>भूमिका</label>
                        <select name="role">
                            <option value="CITIZEN">CITIZEN</option>
                            <option value="WARD_OFFICER">WARD OFFICER</option>
                            <option value="MAYOR">MAYOR</option>
                            <option value="CM">CM</option>
                            <option value="PM">PM</option>
                        </select>
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label>स्थिति</label>
                        <select name="status">
                            <option value="APPROVED">APPROVED</option>
                            <option value="PENDING">PENDING</option>
                        </select>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('createUserModal')">रद्द</button>
                    <button type="submit" class="btn-submit">सुरक्षित गर्नुहोस्</button>
                </div>
            </form>
        </div>
    </div>

    <div id="editUserModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h2>प्रयोगकर्ता सम्पादन</h2>
                <button class="close-modal" onclick="closeModal('editUserModal')">&times;</button>
            </div>
            <form action="AdminComplaintServlet" method="POST" class="admin-form">
                <input type="hidden" name="action" value="editUser">
                <input type="hidden" name="id" id="editUserId">
                <input type="hidden" name="section" value="<%= currentSection %>">
                <div class="form-group">
                    <label>पूरा नाम</label>
                    <input type="text" name="fullName" id="editFullName" required>
                </div>
                <div class="form-group">
                    <label>फोन नम्बर</label>
                    <input type="text" name="phoneNumber" id="editPhoneNumber" required>
                </div>
                <div class="form-group">
                    <label>भूमिका</label>
                    <select name="role" id="editRole">
                        <option value="CITIZEN">CITIZEN</option>
                        <option value="WARD_OFFICER">WARD OFFICER</option>
                        <option value="MAYOR">MAYOR</option>
                        <option value="CM">CM</option>
                        <option value="PM">PM</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>नयाँ पासवर्ड (खाली छोड्नुहोस् यदि परिवर्तन गर्नु छैन भने)</label>
                    <input type="password" name="password" placeholder="********">
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('editUserModal')">रद्द</button>
                    <button type="submit" class="btn-submit">अपडेट गर्नुहोस्</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openCreateModal() {
            document.getElementById('createUserModal').classList.add('active');
        }
        function openEditModal(id, name, phone, role) {
            document.getElementById('editUserId').value = id;
            document.getElementById('editFullName').value = name;
            document.getElementById('editPhoneNumber').value = phone;
            document.getElementById('editRole').value = role;
            document.getElementById('editUserModal').classList.add('active');
        }
        function closeModal(modalId) {
            document.getElementById(modalId).classList.remove('active');
        }
        window.onclick = function(event) {
            if (event.target.classList.contains('modal-overlay')) {
                event.target.classList.remove('active');
            }
        }
    </script>
</body>
</html>
