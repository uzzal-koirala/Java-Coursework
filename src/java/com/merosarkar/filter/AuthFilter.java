package com.merosarkar.filter;

import com.merosarkar.model.User;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(urlPatterns = {"/admin-dashboard.jsp", "/AdminComplaintServlet"})
public class AuthFilter implements Filter {

    public void init(FilterConfig fConfig) throws ServletException {}

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("user") != null;

        if (loggedIn) {
            User user = (User) session.getAttribute("user");
            if (!"CITIZEN".equals(user.getRole())) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(req.getContextPath() + "/index.jsp?error=Unauthorized access");
            }
        } else {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please log in first");
        }
    }

    public void destroy() {}
}
