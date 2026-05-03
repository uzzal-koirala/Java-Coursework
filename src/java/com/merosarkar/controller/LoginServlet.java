package com.merosarkar.controller;

import com.merosarkar.dao.UserDAO;
import com.merosarkar.model.User;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.validateLogin(phoneNumber, password);

        if (user != null) {
            // Session Management
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Cookies
            if (rememberMe != null && rememberMe.equals("on")) {
                Cookie phoneCookie = new Cookie("userPhone", phoneNumber);
                phoneCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                response.addCookie(phoneCookie);
            }

            if ("CITIZEN".equals(user.getRole())) {
                response.sendRedirect("index.jsp");
            } else {
                response.sendRedirect("admin-dashboard.jsp");
            }
        } else {
            response.sendRedirect("login.jsp?error=Invalid phone number or password");
        }
    }
}
