package com.merosarkar.controller;

import com.merosarkar.dao.UserDAO;
import com.merosarkar.model.User;
import com.merosarkar.util.PasswordUtil;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/RegisterServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class RegisterServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "images/profiles";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Handle profile picture upload
        Part filePart = request.getPart("profilePic");
        String fileName = "";
        
        if (filePart != null && filePart.getSize() > 0) {
            fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

            File uploadFolder = new File(uploadFilePath);
            if (!uploadFolder.exists()) {
                uploadFolder.mkdirs();
            }

            filePart.write(uploadFilePath + File.separator + fileName);
        }

        User user = new User();
        user.setFullName(fullName);
        user.setPhoneNumber(phoneNumber);
        user.setPasswordHash(PasswordUtil.hashPassword(password));
        user.setRole(role != null ? role : "CITIZEN");
        user.setProfilePic(fileName.isEmpty() ? null : UPLOAD_DIR + "/" + fileName);

        UserDAO userDAO = new UserDAO();
        if (userDAO.registerUser(user)) {
            response.sendRedirect("login.jsp?success=Registration successful. Please login.");
        } else {
            response.sendRedirect("register.jsp?error=Registration failed. Phone number might already exist.");
        }
    }
}
