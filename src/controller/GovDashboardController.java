package controller;

import dao.GunasoDAO;
import model.Gunaso;
import model.User;
import service.GunasoService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * GovDashboardController – Serves the government official dashboard.
 *
 * Accessible ONLY by users whose role is NOT CITIZEN and NOT SUPER_ADMIN.
 * These are gov officials created by the Super Admin (e.g. WADA_ADAKSHYA,
 * NAGAR_PRAMUKH, PRIME_MINISTER, etc.) who log in via gov-login.jsp.
 */
@WebServlet("/gov-dashboard")
public class GovDashboardController extends HttpServlet {

    private final GunasoService gunasoService = new GunasoService();
    private final GunasoDAO gunasoDAO = new GunasoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        // Must be logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String role = user.getRoleName();

        // Only gov officials allowed — block citizens and super admins
        if ("CITIZEN".equalsIgnoreCase(role) || "SUPER_ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // Fetch complaints assigned to this official's department
        List<Gunaso> complaints;
        if ("PRIME_MINISTER".equalsIgnoreCase(role)) {
            // Prime Minister sees all complaints
            complaints = gunasoService.getAllGunasos();
        } else {
            // Ward/dept officers see only their dept complaints
            Integer deptId = user.getDeptId();
            if (deptId == null || deptId <= 0) {
                complaints = gunasoService.getAllGunasos(); // fallback
            } else {
                complaints = gunasoService.getAssignedGunasos(deptId);
            }
        }

        // Compute stats
        long total      = complaints.size();
        long pending    = complaints.stream().filter(g -> "Pending".equalsIgnoreCase(g.getStatus())).count();
        long inProgress = complaints.stream().filter(g -> "In Progress".equalsIgnoreCase(g.getStatus())).count();
        long resolved   = complaints.stream().filter(g -> "Solved".equalsIgnoreCase(g.getStatus())).count();

        request.setAttribute("complaints", complaints);
        request.setAttribute("totalComplaints",    (int) total);
        request.setAttribute("pendingComplaints",  (int) pending);
        request.setAttribute("inProgressComplaints", (int) inProgress);
        request.setAttribute("resolvedComplaints", (int) resolved);

        request.getRequestDispatcher("/gov/gov-dashboard.jsp").forward(request, response);
    }
}
