package controller;

import model.User;
import service.SuperAdminService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/superadmin/action")
public class SuperAdminController extends HttpServlet {
    private final SuperAdminService superAdminService = new SuperAdminService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Double-check security context
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"SUPER_ADMIN".equals(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/error/unauthorized.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            switch (action) {
                case "updateStatus":
                    handleUpdateStatus(request, response);
                    break;
                case "updateRoleDept":
                    handleUpdateRoleDept(request, response);
                    break;
                case "createOfficial":
                    handleCreateOfficial(request, response);
                    break;
                case "addDept":
                    handleAddDept(request, response);
                    break;
                case "editDept":
                    handleEditDept(request, response);
                    break;
                case "deleteDept":
                    handleDeleteDept(request, response);
                    break;
                case "updateSettings":
                    handleUpdateSettings(request, response);
                    break;
                case "deleteUser":
                    handleDeleteUser(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getHeader("referer"));
        }
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String status = request.getParameter("status");
        
        // Prevent Super Admin from deactivating themselves
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser.getId() == userId) {
            request.getSession().setAttribute("error", "You cannot deactivate your own account!");
            response.sendRedirect(request.getHeader("referer"));
            return;
        }

        if (superAdminService.updateUserStatus(userId, status)) {
            request.getSession().setAttribute("success", "User status updated successfully to: " + status);
        } else {
            request.getSession().setAttribute("error", "Failed to update user status.");
        }
        response.sendRedirect(request.getHeader("referer"));
    }

    private void handleUpdateRoleDept(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        String deptStr = request.getParameter("deptId");
        Integer deptId = (deptStr == null || deptStr.trim().isEmpty()) ? null : Integer.parseInt(deptStr);

        // Prevent Super Admin from changing their own role
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser.getId() == userId) {
            request.getSession().setAttribute("error", "You cannot change your own role!");
            response.sendRedirect(request.getHeader("referer"));
            return;
        }

        if (superAdminService.updateUserRoleAndDept(userId, roleId, deptId)) {
            request.getSession().setAttribute("success", "User credentials updated successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to update user role and department.");
        }
        response.sendRedirect(request.getHeader("referer"));
    }

    private void handleCreateOfficial(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        String deptStr = request.getParameter("deptId");
        Integer deptId = (deptStr == null || deptStr.trim().isEmpty() || "-1".equals(deptStr)) ? null : Integer.parseInt(deptStr);

        if (fullName == null || email == null || password == null || phone == null ||
            fullName.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() || phone.trim().isEmpty()) {
            request.getSession().setAttribute("error", "All fields are required to create an official account.");
            response.sendRedirect(request.getHeader("referer"));
            return;
        }

        User u = new User();
        u.setFullName(fullName.trim());
        u.setEmail(email.trim());
        u.setPassword(password);
        u.setPhone(phone.trim());
        u.setRoleId(roleId);
        u.setDeptId(deptId);

        // Standard validation check for duplicate email/phone is handled inside registration, but we can do a try-catch
        if (superAdminService.createOfficialUser(u)) {
            request.getSession().setAttribute("success", "Official account created successfully for: " + fullName);
        } else {
            request.getSession().setAttribute("error", "Failed to create official account. Email or Phone might already exist.");
        }
        response.sendRedirect(request.getHeader("referer"));
    }

    private void handleAddDept(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String deptName = request.getParameter("deptName");
        if (deptName == null || deptName.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Department name cannot be empty.");
            response.sendRedirect(request.getHeader("referer"));
            return;
        }

        if (superAdminService.addDepartment(deptName)) {
            request.getSession().setAttribute("success", "Department '" + deptName + "' added successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to add department. Name might be a duplicate.");
        }
        response.sendRedirect(request.getHeader("referer"));
    }

    private void handleEditDept(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int deptId = Integer.parseInt(request.getParameter("deptId"));
        String deptName = request.getParameter("deptName");
        if (deptName == null || deptName.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Department name cannot be empty.");
            response.sendRedirect(request.getHeader("referer"));
            return;
        }

        if (superAdminService.updateDepartment(deptId, deptName)) {
            request.getSession().setAttribute("success", "Department updated successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to update department.");
        }
        response.sendRedirect(request.getHeader("referer"));
    }

    private void handleDeleteDept(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int deptId = Integer.parseInt(request.getParameter("deptId"));

        // Verify no officials/tickets are actively assigned, or let the DB foreign key block it.
        // The service will attempt to delete, and if DB foreign keys fail, it returns false.
        if (superAdminService.deleteDepartment(deptId)) {
            request.getSession().setAttribute("success", "Department deleted successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to delete department. Verify that no officers or grievances are currently assigned to it.");
        }
        response.sendRedirect(request.getHeader("referer"));
    }

    private void handleUpdateSettings(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String maintenanceMode = request.getParameter("maintenanceMode");
        String passwordComplexity = request.getParameter("passwordComplexity");
        String backupFrequency = request.getParameter("backupFrequency");
        String sessionTimeout = request.getParameter("sessionTimeout");
        String themeMode = request.getParameter("themeMode");

        // We can write this into the ServletContext so it's a global config that stays alive!
        request.getServletContext().setAttribute("sys_maintenanceMode", "on".equals(maintenanceMode) ? "Enabled" : "Disabled");
        request.getServletContext().setAttribute("sys_passwordComplexity", passwordComplexity);
        request.getServletContext().setAttribute("sys_backupFrequency", backupFrequency);
        request.getServletContext().setAttribute("sys_sessionTimeout", sessionTimeout + " Minutes");
        request.getServletContext().setAttribute("sys_themeMode", themeMode != null ? themeMode : "light");
        
        request.getSession().setAttribute("superAdminTheme", themeMode != null ? themeMode : "light");

        request.getSession().setAttribute("success", "System configurations updated successfully!");
        response.sendRedirect(request.getHeader("referer"));
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser.getId() == userId) {
            request.getSession().setAttribute("error", "You cannot delete your own account!");
            response.sendRedirect(request.getHeader("referer"));
            return;
        }

        if (superAdminService.deleteUser(userId)) {
            request.getSession().setAttribute("success", "User deleted successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to delete user. Please ensure they have no associated records.");
        }
        response.sendRedirect(request.getHeader("referer"));
    }
}
