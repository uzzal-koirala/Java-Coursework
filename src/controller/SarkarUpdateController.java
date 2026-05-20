package controller;

import dao.SarkarUpdateDAO;
import model.SarkarUpdate;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/user/sarkar-updates")
public class SarkarUpdateController extends HttpServlet {

    private final SarkarUpdateDAO updateDAO = new SarkarUpdateDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        // Fetch all updates and attach them to the request
        List<SarkarUpdate> feed = updateDAO.getAllUpdates(user.getId());
        request.setAttribute("feed", feed);

        request.getRequestDispatcher("/user/sarkar-updates.jsp").forward(request, response);
    }
}
