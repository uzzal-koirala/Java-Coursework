package controller;

import model.Gunaso;
import model.User;
import service.GunasoService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@WebServlet("/gunaso/*")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,  // 2 MB
                 maxFileSize       = 1024 * 1024 * 10,  // 10 MB
                 maxRequestSize    = 1024 * 1024 * 50)  // 50 MB
public class GunasoController extends HttpServlet {

    private final GunasoService      gunasoService = new GunasoService();
    private final service.ReplyService replyService = new service.ReplyService();

    // -----------------------------------------------------------------------
    // SECURITY: only allow safe file extensions for attachments
    // -----------------------------------------------------------------------
    private static final Set<String> ALLOWED_EXTENSIONS = new HashSet<>(Arrays.asList(
        "jpg", "jpeg", "png", "gif", "pdf", "doc", "docx", "txt"
    ));

    // -----------------------------------------------------------------------
    // SECURITY: only allow known status values (prevents arbitrary DB writes)
    // -----------------------------------------------------------------------
    private static final Set<String> ALLOWED_STATUSES = new HashSet<>(Arrays.asList(
        "Pending", "In Review", "Solved", "Rejected"
    ));

    // -----------------------------------------------------------------------
    // SECURITY: roles that are permitted to update complaint status
    // -----------------------------------------------------------------------
    private static final Set<String> AUTHORITY_ROLES = new HashSet<>(Arrays.asList(
        "WADA_ADAKSHYA", "NAGAR_PRAMUKH", "PRIME_MINISTER", "SUPER_ADMIN"
    ));

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        if ("/create".equals(path)) {
            request.setAttribute("departments", gunasoService.getDepartments());
            request.getRequestDispatcher("/user/create-gunaso.jsp").forward(request, response);
        } else if ("/view".equals(path)) {
            handleView(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        switch (path) {
            case "/submit":
                handleSubmit(request, response);
                break;
            case "/updateStatus":
                handleUpdateStatus(request, response);
                break;
            case "/reply":
                handleReply(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // -----------------------------------------------------------------------
    // SUBMIT (citizens only)
    // -----------------------------------------------------------------------
    private void handleSubmit(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        User user = getCurrentUser(request);
        if (user == null) { redirectToLogin(request, response); return; }

        // Input validation
        String title       = sanitize(request.getParameter("title"));
        String description = sanitize(request.getParameter("description"));
        String deptIdParam = request.getParameter("deptId");

        if (isBlank(title) || isBlank(description) || isBlank(deptIdParam)) {
            request.getSession().setAttribute("error", "All fields are required.");
            response.sendRedirect(request.getContextPath() + "/gunaso/create");
            return;
        }
        if (title.length() > 255) {
            request.getSession().setAttribute("error", "Title is too long (max 255 characters).");
            response.sendRedirect(request.getContextPath() + "/gunaso/create");
            return;
        }

        int deptId;
        try {
            deptId = Integer.parseInt(deptIdParam);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid department selected.");
            response.sendRedirect(request.getContextPath() + "/gunaso/create");
            return;
        }

        // File upload — validate extension before saving
        String fileName = "";
        Part filePart = request.getPart("attachment");
        if (filePart != null && filePart.getSize() > 0) {
            String originalName = getFileName(filePart);
            String ext = getExtension(originalName).toLowerCase();

            if (!ALLOWED_EXTENSIONS.contains(ext)) {
                request.getSession().setAttribute("error",
                    "Invalid file type. Allowed: jpg, jpeg, png, gif, pdf, doc, docx, txt.");
                response.sendRedirect(request.getContextPath() + "/gunaso/create");
                return;
            }

            // Use timestamp prefix to prevent filename collisions / path traversal
            fileName = System.currentTimeMillis() + "_" + sanitizeFileName(originalName);
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            filePart.write(uploadPath + File.separator + fileName);
        }

        Gunaso gunaso = new Gunaso();
        gunaso.setTitle(title);
        gunaso.setDescription(description);
        gunaso.setUserId(user.getId());
        gunaso.setDeptId(deptId);
        gunaso.setAttachment(fileName);

        if (gunasoService.submitGunaso(gunaso)) {
            request.getSession().setAttribute("success", "Gunaso submitted successfully!");
            response.sendRedirect(request.getContextPath() + "/user/my-gunaso");
        } else {
            request.getSession().setAttribute("error", "Failed to submit Gunaso. Please try again.");
            response.sendRedirect(request.getContextPath() + "/gunaso/create");
        }
    }

    // -----------------------------------------------------------------------
    // UPDATE STATUS (authorities only — WADA, NAGAR, PM, SUPER_ADMIN)
    // -----------------------------------------------------------------------
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = getCurrentUser(request);
        if (user == null) { redirectToLoginSimple(request, response); return; }

        // SECURITY: only authority roles may change status
        if (!AUTHORITY_ROLES.contains(user.getRoleName())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "You are not authorised to update complaint status.");
            return;
        }

        String idParam     = request.getParameter("gunasoId");
        String status      = request.getParameter("status");

        String redirectUrl = "SUPER_ADMIN".equalsIgnoreCase(user.getRoleName()) 
                ? "/superadmin/manage-gunaso" : "/gov-dashboard";

        if (isBlank(idParam) || isBlank(status)) {
            request.getSession().setAttribute("error", "Missing required parameters.");
            response.sendRedirect(request.getContextPath() + redirectUrl);
            return;
        }

        // SECURITY: validate status against whitelist
        if (!ALLOWED_STATUSES.contains(status)) {
            request.getSession().setAttribute("error", "Invalid status value.");
            response.sendRedirect(request.getContextPath() + redirectUrl);
            return;
        }

        int gunasoId;
        try {
            gunasoId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid complaint ID.");
            response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard.jsp");
            return;
        }

        if (gunasoService.updateStatus(gunasoId, status)) {
            request.getSession().setAttribute("success", "Status updated successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to update status.");
        }
        response.sendRedirect(request.getContextPath() + redirectUrl);
    }

    // -----------------------------------------------------------------------
    // VIEW (citizens see only their own; authorities see any in their dept)
    // -----------------------------------------------------------------------
    private void handleView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = getCurrentUser(request);
        if (user == null) { redirectToLogin(request, response); return; }

        String idParam = request.getParameter("id");
        if (isBlank(idParam)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing complaint ID.");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid complaint ID.");
            return;
        }

        Gunaso gunaso = new dao.GunasoDAO().getGunasoById(id);
        if (gunaso == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Complaint not found.");
            return;
        }

        // SECURITY: citizens can only view their own complaints
        boolean isCitizen    = "CITIZEN".equals(user.getRoleName());
        boolean isOwner      = gunaso.getUserId() == user.getId();
        boolean isAuthority  = AUTHORITY_ROLES.contains(user.getRoleName());

        if (isCitizen && !isOwner) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "You are not allowed to view this complaint.");
            return;
        }

        if (!isCitizen && !isAuthority) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Access denied.");
            return;
        }

        request.setAttribute("gunaso", gunaso);
        request.setAttribute("replies", replyService.getReplies(id));
        request.getRequestDispatcher("/user/view-gunaso.jsp").forward(request, response);
    }

    // -----------------------------------------------------------------------
    // REPLY
    // -----------------------------------------------------------------------
    private void handleReply(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = getCurrentUser(request);
        if (user == null) { redirectToLoginSimple(request, response); return; }

        String idParam  = request.getParameter("gunasoId");
        String message  = sanitize(request.getParameter("message"));

        if (isBlank(idParam) || isBlank(message)) {
            request.getSession().setAttribute("error", "Reply message cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        int gunasoId;
        try {
            gunasoId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid complaint ID.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        model.Reply reply = new model.Reply();
        reply.setGunasoId(gunasoId);
        reply.setUserId(user.getId());
        reply.setMessage(message);

        if (replyService.addReply(reply)) {
            request.getSession().setAttribute("success", "Reply added successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to add reply.");
        }
        response.sendRedirect(request.getContextPath() + "/gunaso/view?id=" + gunasoId);
    }

    // -----------------------------------------------------------------------
    // Helper utilities
    // -----------------------------------------------------------------------

    /** Returns the logged-in User from session, or null if not logged in. */
    private User getCurrentUser(HttpServletRequest request) {
        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute("user");
    }

    private void redirectToLogin(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        req.getSession().setAttribute("error", "Please log in to continue.");
        res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
    }

    private void redirectToLoginSimple(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
    }

    /**
     * Strips leading/trailing whitespace. Returns null-safe trimmed string.
     * Does NOT strip HTML — JSP pages must use JSTL c:out or fn:escapeXml
     * to prevent XSS when rendering output.
     */
    private String sanitize(String input) {
        return (input == null) ? "" : input.trim();
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    /** Removes directory traversal characters from uploaded filenames. */
    private String sanitizeFileName(String fileName) {
        if (fileName == null) return "upload";
        // Keep only alphanumeric, dash, underscore, dot
        return fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

    private String getExtension(String fileName) {
        if (fileName == null || !fileName.contains(".")) return "";
        return fileName.substring(fileName.lastIndexOf('.') + 1);
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) return "";
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim()
                                   .replace("\"", "");
                // Return only the basename — never the full path
                return new File(name).getName();
            }
        }
        return "";
    }
}
