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

@WebServlet("/superadmin/manage-gunaso")
public class ManageAllGunasoController extends HttpServlet {
    private final GunasoService gunasoService = new GunasoService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"SUPER_ADMIN".equalsIgnoreCase(user.getRoleName())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // Fetch all complaints from all departments
        List<Gunaso> gunasos = new dao.GunasoDAO().getAllGunasos();
        request.setAttribute("gunasos", gunasos);

        request.getRequestDispatcher("/superadmin/manage-gunaso.jsp").forward(request, response);
    }
}
