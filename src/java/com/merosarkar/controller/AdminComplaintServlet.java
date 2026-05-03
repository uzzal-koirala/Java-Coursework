package com.merosarkar.controller;

import com.merosarkar.dao.ComplaintDAO;
import com.merosarkar.dao.UserDAO;
import com.merosarkar.model.Complaint;
import com.merosarkar.model.User;
import com.merosarkar.util.PasswordUtil;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AdminComplaintServlet")
public class AdminComplaintServlet extends HttpServlet {
    
    private ComplaintDAO complaintDAO = new ComplaintDAO();
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if ("CITIZEN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<Complaint> complaints = complaintDAO.getAllComplaints();
        List<User> users = userDAO.getAllUsers();
        
        request.setAttribute("complaints", complaints);
        request.setAttribute("users", users);
        
        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            
            if ("updateComplaint".equals(action)) {
                String status = request.getParameter("status");
                complaintDAO.updateComplaintStatus(id, status);
            } else if ("deleteComplaint".equals(action)) {
                complaintDAO.deleteComplaint(id);
            } else if ("updateUserStatus".equals(action)) {
                String status = request.getParameter("status");
                userDAO.updateUserStatus(id, status);
            } else if ("deleteUser".equals(action)) {
                userDAO.deleteUser(id);
            } else if ("editUser".equals(action)) {
                String fullName = request.getParameter("fullName");
                String phoneNumber = request.getParameter("phoneNumber");
                String role = request.getParameter("role");
                String password = request.getParameter("password");
                userDAO.updateUserDetails(id, fullName, phoneNumber, role, password);
            }
        } else if ("createUser".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phoneNumber = request.getParameter("phoneNumber");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String status = request.getParameter("status");
            
            User newUser = new User();
            newUser.setFullName(fullName);
            newUser.setPhoneNumber(phoneNumber);
            newUser.setPasswordHash(PasswordUtil.hashPassword(password));
            newUser.setRole(role);
            newUser.setStatus(status);
            
            userDAO.createUserAdmin(newUser);
        }
        
        String section = request.getParameter("section");
        if (section != null && !section.isEmpty()) {
            response.sendRedirect("AdminComplaintServlet?section=" + section);
        } else {
            response.sendRedirect("AdminComplaintServlet");
        }
    }
}
