package controller;

import dao.SarkarUpdateDAO;
import model.SarkarUpdate;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/user/sarkar-updates/action")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class SarkarUpdateActionController extends HttpServlet {

    private final SarkarUpdateDAO updateDAO = new SarkarUpdateDAO();
    private static final String UPLOAD_DIR = "uploads" + File.separator + "updates";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login first.");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("post".equals(action)) {
            handlePostUpdate(request, response, user);
        } else if ("like".equals(action)) {
            handleLike(request, response, user);
        } else if ("comment".equals(action)) {
            handleComment(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/user/sarkar-updates");
        }
    }

    private void handlePostUpdate(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        // Only non-citizens can post
        if ("CITIZEN".equals(user.getRoleName())) {
            sessionMsg(request, "error", "Citizens cannot post updates.");
            response.sendRedirect(request.getContextPath() + "/user/sarkar-updates");
            return;
        }

        String content = request.getParameter("content");
        Part filePart = request.getPart("photo");
        String photoUrl = null;

        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String fileName = UUID.randomUUID().toString() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            filePart.write(uploadPath + File.separator + fileName);
            photoUrl = UPLOAD_DIR + "/" + fileName;
            photoUrl = photoUrl.replace("\\", "/");
        }

        if (content == null || content.trim().isEmpty()) {
            sessionMsg(request, "error", "Content cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/user/sarkar-updates");
            return;
        }

        SarkarUpdate update = new SarkarUpdate();
        update.setUserId(user.getId());
        update.setContent(content);
        update.setPhotoUrl(photoUrl);

        if (updateDAO.createUpdate(update)) {
            sessionMsg(request, "success", "Update posted successfully!");
        } else {
            sessionMsg(request, "error", "Failed to post update. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/user/sarkar-updates");
    }

    private void handleLike(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        String redirect = request.getParameter("redirect");
        try {
            int updateId = Integer.parseInt(request.getParameter("updateId"));
            updateDAO.toggleLike(updateId, user.getId());
        } catch (NumberFormatException e) {
            // Log error
        }
        if ("dashboard".equals(redirect)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/sarkar-updates");
        }
    }

    private void handleComment(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        String redirect = request.getParameter("redirect");
        try {
            int updateId = Integer.parseInt(request.getParameter("updateId"));
            String comment = request.getParameter("comment");
            if (comment != null && !comment.trim().isEmpty()) {
                updateDAO.addComment(updateId, user.getId(), comment);
            }
        } catch (NumberFormatException e) {
            // Log error
        }
        if ("dashboard".equals(redirect)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/sarkar-updates");
        }
    }

    private void sessionMsg(HttpServletRequest request, String type, String msg) {
        request.getSession().setAttribute(type, msg);
    }
}
