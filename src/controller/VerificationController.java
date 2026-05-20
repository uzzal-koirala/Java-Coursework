package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/verify")
public class VerificationController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User admin = (User) request.getSession().getAttribute("user");
        if (admin == null || (!"SUPER_ADMIN".equals(admin.getRoleName()) && !"WADA_ADAKSHYA".equals(admin.getRoleName()) && !"NAGAR_PRAMUKH".equals(admin.getRoleName()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access");
            return;
        }

        try {
            int targetUserId = Integer.parseInt(request.getParameter("userId"));
            String action = request.getParameter("action"); // 'approve' or 'reject'
            
            String newStatus = "approve".equalsIgnoreCase(action) ? "Verified" : "Unverified";
            
            boolean success = userDAO.updateVerificationStatus(targetUserId, newStatus);
            
            if (success) {
                request.getSession().setAttribute("success", "User verification status updated to " + newStatus);
            } else {
                request.getSession().setAttribute("error", "Failed to update verification status.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Invalid request parameters.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/verify-requests.jsp");
    }
}
