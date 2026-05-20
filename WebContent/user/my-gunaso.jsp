<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Gunaso, model.User, model.Department, dao.GunasoDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mero Gunaso - Gunaso Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <script src="<%= request.getContextPath() %>/js/script.js" defer></script>
    <style>
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.4); backdrop-filter: blur(8px);
            z-index: 1000; display: flex; justify-content: center; align-items: center;
            opacity: 0; pointer-events: none; transition: all 0.3s ease;
        }
        .modal-overlay.active { opacity: 1; pointer-events: auto; }
        .modal-content-card {
            background: rgba(255, 255, 255, 0.96); border-radius: 24px; width: 100%; max-width: 600px;
            box-shadow: 0 30px 60px -15px rgba(15, 23, 42, 0.3), 0 0 0 1px rgba(255, 255, 255, 0.5) inset;
            transform: scale(0.92); transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); overflow: hidden;
            backdrop-filter: blur(10px);
        }
        .modal-overlay.active .modal-content-card { transform: scale(1); }
        .modal-header {
            background: linear-gradient(135deg, var(--primary) 0%, #1e40af 100%); color: #ffffff; padding: 22px 28px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 20px rgba(30, 58, 138, 0.15);
        }
        .modal-close-btn { background: none; border: none; color: #ffffff; font-size: 1.3rem; cursor: pointer; opacity: 0.8; transition: all 0.2s; }
        .modal-close-btn:hover { opacity: 1; transform: rotate(90deg); }
        .modal-body { padding: 28px; }
        
        .modal-body input[type="text"],
        .modal-body select,
        .modal-body textarea {
            width: 100%;
            padding: 13px 16px;
            border-radius: 12px;
            border: 1px solid #cbd5e1;
            background: #f8fafc;
            outline: none;
            font-family: inherit;
            font-size: 0.95rem;
            color: #1e293b;
            transition: all 0.3s ease;
        }
        .modal-body input[type="text"]:focus,
        .modal-body select:focus,
        .modal-body textarea:focus {
            border-color: var(--primary);
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(30, 58, 138, 0.1);
        }
        
        /* Premium File Upload Dropzone */
        .file-upload-zone {
            border: 2px dashed #cbd5e1;
            border-radius: 16px;
            padding: 24px;
            text-align: center;
            background: #f8fafc;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }
        .file-upload-zone:hover {
            border-color: var(--primary);
            background: rgba(30, 58, 138, 0.02);
        }
        .upload-icon {
            font-size: 2.2rem;
            color: var(--primary);
            margin-bottom: 10px;
            transition: transform 0.3s ease;
            display: inline-block;
        }
        .file-upload-zone:hover .upload-icon {
            transform: translateY(-4px);
        }
        .upload-text {
            font-weight: 600;
            color: #334155;
            font-size: 0.95rem;
            margin-bottom: 4px;
        }
        .browse-link {
            color: var(--primary);
            text-decoration: underline;
        }
        .upload-note {
            font-size: 0.78rem;
            color: #64748b;
        }
        .file-preview {
            margin-top: 12px;
            display: flex;
            align-items: center;
            gap: 12px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            padding: 8px 12px;
            border-radius: 10px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }
        .file-preview-icon {
            font-size: 1.2rem;
            color: #10b981;
        }
        .file-name {
            font-size: 0.88rem;
            color: #334155;
            font-weight: 500;
            text-overflow: ellipsis;
            white-space: nowrap;
            overflow: hidden;
            flex: 1;
            text-align: left;
        }
        .remove-file-btn {
            background: none;
            border: none;
            color: #64748b;
            cursor: pointer;
            padding: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            transition: all 0.2s;
        }
        .remove-file-btn:hover {
            background: #f1f5f9;
            color: #ef4444;
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <jsp:include page="/components/sidebar.jsp" />
        
        <main class="main-content">
            <div class="top-bar">
                <div class="page-title">
                    <h1>Mero Gunaso</h1>
                    <p>Track the status of all your submitted complaints</p>
                </div>
                <div class="top-actions" style="display: flex; align-items: center;">
                    <button onclick="openAddModal()" style="background: var(--primary); color: white; border: none; padding: 12px 24px; border-radius: 8px; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 8px; box-shadow: 0 4px 15px rgba(30, 58, 138, 0.3); font-size: 1.05rem; transition: all 0.3s;">
                        <i class="fa-solid fa-plus"></i> Lodge New Gunaso
                    </button>
                </div>
            </div>
            
            <div class="dashboard-body">
                <% 
                    String error = (String) session.getAttribute("error");
                    if (error != null) {
                %>
                    <div style="background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.3); color: #ef4444; padding: 15px; border-radius: 12px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px;">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <span><%= error %></span>
                    </div>
                <% 
                        session.removeAttribute("error");
                    }
                %>
                <% 
                    String success = (String) session.getAttribute("success");
                    if (success != null) {
                %>
                    <div style="background: rgba(16, 185, 129, 0.15); border: 1px solid rgba(16, 185, 129, 0.3); color: #10b981; padding: 15px; border-radius: 12px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px;">
                        <i class="fa-solid fa-circle-check"></i>
                        <span><%= success %></span>
                    </div>
                <% 
                        session.removeAttribute("success");
                    }
                %>

                <div class="section-header" style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #e2e8f0; padding-bottom: 15px; margin-bottom: 20px;">
                    <h2>All Mero Gunaso</h2>
                </div>
                <!-- Force Tomcat Recompile V2 -->

                <div class="data-table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Tracking ID</th>
                                <th>Issue Title</th>
                                <th>Assigned Dept</th>
                                <th>Current Status</th>
                                <th>Filed Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                // In a real app this should come from a controller, but since they hit this page directly for now,
                                // we will instantiate the service here, OR better yet, let's redirect them to DashboardController
                                // Wait! Let's do the proper MVC way: request.getAttribute("gunasos")
                                List<Gunaso> gunasos = (List<Gunaso>) request.getAttribute("gunasos");
                                if (gunasos != null && !gunasos.isEmpty()) {
                                    for (Gunaso g : gunasos) {
                                        String badgeClass = "badge-pending";
                                        String status = g.getStatus().toLowerCase();
                                        if (status.contains("review") || status.contains("progress")) badgeClass = "badge-review";
                                        if (status.contains("solve") || status.contains("resolv")) badgeClass = "badge-resolved";
                                        if (status.contains("reject")) badgeClass = "badge-rejected";
                            %>
                                <tr>
                                    <td class="id-col">#<%= g.getId() %></td>
                                    <td class="title-col"><%= g.getTitle() %></td>
                                    <td><%= g.getDeptName() %></td>
                                    <td>
                                        <span class="badge <%= badgeClass %>"><%= g.getStatus() %></span>
                                    </td>
                                    <td><%= g.getCreatedAt() %></td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/gunaso/view?id=<%= g.getId() %>" class="btn-view">
                                            <i class="fa-regular fa-eye"></i> View
                                        </a>
                                    </td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 40px; color: var(--text-light);">
                                        <i class="fa-solid fa-inbox" style="font-size: 3rem; opacity: 0.2; margin-bottom: 15px; display: block;"></i>
                                        No grievances found. 
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Add Gunaso Modal -->
    <div class="modal-overlay" id="addGunasoModal">
        <div class="modal-content-card">
            <div class="modal-header">
                <h3 style="font-weight: 700;">Submit New Complaint</h3>
                <button class="modal-close-btn" onclick="closeAddModal()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <% 
                model.User u = (model.User) session.getAttribute("user");
                String vStatus = u != null ? u.getVerificationStatus() : "Unverified";
                if ("Verified".equals(vStatus)) {
            %>
            <form action="<%= request.getContextPath() %>/gunaso/submit" method="POST" enctype="multipart/form-data">
                <div class="modal-body">
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label for="title" style="display: block; margin-bottom: 8px; font-weight: 600; color: #334155; font-size: 0.9rem;">Title / Subject</label>
                        <input type="text" id="title" name="title" placeholder="Brief subject of your grievance" required>
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label for="deptId" style="display: block; margin-bottom: 8px; font-weight: 600; color: #334155; font-size: 0.9rem;">Department</label>
                        <select id="deptId" name="deptId" required>
                            <option value="">Select Department</option>
                            <% 
                                GunasoDAO gunasoDAO = new GunasoDAO();
                                List<Department> depts = gunasoDAO.getAllDepartments();
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
                        <label for="description" style="display: block; margin-bottom: 8px; font-weight: 600; color: #334155; font-size: 0.9rem;">Detailed Description</label>
                        <textarea id="description" name="description" rows="4" placeholder="Explain your issue in detail..." required style="resize: vertical;"></textarea>
                    </div>

                    <div class="form-group" style="margin-bottom: 10px;">
                        <label for="attachment" style="display: block; margin-bottom: 8px; font-weight: 600; color: #334155; font-size: 0.9rem;">Attachment (Optional)</label>
                        <input type="file" id="attachment" name="attachment" style="display: none;" onchange="handleFileSelect(event)">
                        <div class="file-upload-zone" onclick="document.getElementById('attachment').click();">
                            <i class="fa-solid fa-cloud-arrow-up upload-icon"></i>
                            <div class="upload-text">Drag & drop files here or <span class="browse-link">browse</span></div>
                            <div class="upload-note">Supports PNG, JPG, JPEG (Max 5MB)</div>
                            <div class="file-preview" id="filePreview" style="display: none;">
                                <i class="fa-solid fa-circle-check file-preview-icon"></i>
                                <span class="file-name" id="fileName">No file selected</span>
                                <button type="button" class="remove-file-btn" onclick="event.stopPropagation(); removeSelectedFile();"><i class="fa-solid fa-xmark"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="padding: 20px 28px; border-top: 1px solid #e2e8f0; display: flex; justify-content: flex-end; gap: 12px; background: #f8fafc;">
                    <button type="button" class="btn-cancel" onclick="closeAddModal()" style="background: #e2e8f0; color: #475569; border: none; padding: 11px 22px; border-radius: 10px; font-weight: 600; cursor: pointer; transition: all 0.3s; font-size: 0.92rem;">Cancel</button>
                    <button type="submit" style="background: linear-gradient(135deg, var(--primary) 0%, #1e40af 100%); color: white; border: none; padding: 11px 22px; border-radius: 10px; font-weight: 600; cursor: pointer; transition: all 0.3s; font-size: 0.92rem; box-shadow: 0 4px 12px rgba(30, 58, 138, 0.25);">Submit Gunaso</button>
                </div>
            </form>
            <% } else { %>
                <div class="modal-body" style="text-align: center; padding: 40px 20px;">
                    <div style="width: 70px; height: 70px; background: rgba(245, 158, 11, 0.1); color: #f59e0b; font-size: 2rem; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <h3 style="color: var(--primary); margin-bottom: 10px;">Verification Required</h3>
                    <p style="color: var(--text-light); margin-bottom: 25px;">You must verify your citizenship details before lodging a complaint.</p>
                    <a href="<%= request.getContextPath() %>/user/profile.jsp" style="display: inline-block; background: var(--primary); color: white; text-decoration: none; padding: 10px 20px; border-radius: 8px; font-weight: 600;">Go to Settings</a>
                </div>
            <% } %>
        </div>
    </div>

    <script>
        function openAddModal() {
            document.getElementById('addGunasoModal').classList.add('active');
        }

        function closeAddModal() {
            document.getElementById('addGunasoModal').classList.remove('active');
        }

        // Close on outside click
        window.onclick = function(event) {
            var modal = document.getElementById('addGunasoModal');
            if (event.target == modal) {
                closeAddModal();
            }
        }

        // Handle attachment file selection and custom dropzone state
        function handleFileSelect(event) {
            const input = event.target;
            const file = input.files[0];
            const preview = document.getElementById('filePreview');
            const fileNameSpan = document.getElementById('fileName');
            
            if (file) {
                fileNameSpan.textContent = file.name;
                preview.style.display = 'flex';
            } else {
                preview.style.display = 'none';
            }
        }

        function removeSelectedFile() {
            const input = document.getElementById('attachment');
            input.value = '';
            const preview = document.getElementById('filePreview');
            preview.style.display = 'none';
        }
    </script>
</body>
</html>
