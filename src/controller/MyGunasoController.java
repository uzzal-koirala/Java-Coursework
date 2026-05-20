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

@WebServlet("/user/my-gunaso")
public class MyGunasoController extends HttpServlet {
    private final GunasoService gunasoService = new GunasoService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // Fetch user's complaints
        List<Gunaso> gunasos = gunasoService.getMyGunasos(user.getId());
        request.setAttribute("gunasos", gunasos);

        request.getRequestDispatcher("/user/my-gunaso.jsp").forward(request, response);
    }
}
