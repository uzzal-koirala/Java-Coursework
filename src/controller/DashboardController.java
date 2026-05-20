package controller;

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

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {
    private GunasoService gunasoService = new GunasoService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String role = user.getRoleName();
        if ("CITIZEN".equals(role)) {
            List<Gunaso> myGunasos = gunasoService.getMyGunasos(user.getId());
            request.setAttribute("gunasos", myGunasos);
            
            // Fetch Sarkar Updates feed for the citizen dashboard
            dao.SarkarUpdateDAO updateDAO = new dao.SarkarUpdateDAO();
            List<model.SarkarUpdate> feed = updateDAO.getAllUpdates(user.getId());
            request.setAttribute("feed", feed);
            
            request.getRequestDispatcher("/user/user-dashboard.jsp").forward(request, response);
        } else if ("SUPER_ADMIN".equals(role)) {
            service.SuperAdminService superService = new service.SuperAdminService();
            request.setAttribute("stats", superService.getSystemStats());
            request.setAttribute("activities", superService.getSystemActivities());
            request.getRequestDispatcher("/superadmin/super-dashboard.jsp").forward(request, response);
        } else {
            // All other roles are government officials (PRIME_MINISTER, WADA_ADAKSHYA, NAGAR_PRAMUKH, etc.)
            response.sendRedirect(request.getContextPath() + "/gov-dashboard");
        }
    }
}
