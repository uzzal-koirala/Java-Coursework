package controller;

import model.User;
import service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet(urlPatterns = {"/auth/login", "/auth/register", "/auth/logout"})
public class AuthController extends HttpServlet {

    private final AuthService authService = new AuthService();

    // Email regex — simple but effective for server-side validation
    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$");

    // Nepali phone: 10 digits, optionally starting with +977
    private static final Pattern PHONE_PATTERN =
        Pattern.compile("^(\\+977)?[0-9]{10}$");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/auth/login".equals(path)) {
            handleLogin(request, response);
        } else if ("/auth/register".equals(path)) {
            handleRegister(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/auth/logout".equals(path)) {
            handleLogout(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // -----------------------------------------------------------------------
    // LOGIN
    // -----------------------------------------------------------------------
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email    = trim(request.getParameter("email"));
        String password = request.getParameter("password");

        String loginType = request.getParameter("loginType");

        // Determine redirect URL on failure based on portal type
        String failUrl;
        if ("superadmin".equals(loginType)) {
            failUrl = "/auth/super-login.jsp";
        } else if ("gov".equals(loginType)) {
            failUrl = "/gov-portal.jsp";
        } else {
            failUrl = "/auth/login.jsp";
        }

        // Basic presence validation
        if (isBlank(email) || isBlank(password)) {
            setError(request, "Email and password are required.");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // Email format check (prevents sending arbitrary strings to DB)
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            setError(request, "Please enter a valid email address.");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            User user = authService.login(email, password);
            if (user != null) {
                // Check if account is active
                if (!"Active".equalsIgnoreCase(user.getStatus())) {
                    setError(request, "Your account has been deactivated. Please contact the Super Administrator.");
                    response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
                    return;
                }

                String role = user.getRoleName();
                boolean isCitizen    = "CITIZEN".equalsIgnoreCase(role);
                boolean isSuperAdmin = "SUPER_ADMIN".equalsIgnoreCase(role);
                boolean isGovUser    = !isCitizen && !isSuperAdmin;

                // Regenerate session to prevent session fixation attacks
                request.getSession().invalidate();
                HttpSession newSession = request.getSession(true);
                newSession.setAttribute("user", user);

                // Route to the correct dashboard based on role
                if (isGovUser) {
                    response.sendRedirect(request.getContextPath() + "/gov-dashboard");
                } else if (isSuperAdmin) {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                }

            } else {
                // Generic message — do not reveal whether email or password was wrong
                setError(request, "Invalid email or password.");
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            }
        } catch (RuntimeException e) {
            e.printStackTrace();
            setError(request, "Database connectivity error. Please try again later.");
            response.sendRedirect(request.getContextPath() + failUrl);
        }
    }

    // -----------------------------------------------------------------------
    // REGISTER
    // -----------------------------------------------------------------------
    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String fullName        = trim(request.getParameter("fullName"));
        String email           = trim(request.getParameter("email"));
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone           = trim(request.getParameter("phone"));

        // 1. Presence checks
        if (isBlank(fullName) || isBlank(email) || isBlank(password)
                || isBlank(confirmPassword) || isBlank(phone)) {
            setError(request, "All fields are required.");
            response.sendRedirect(request.getContextPath() + "/auth/register.jsp");
            return;
        }

        // 2. Full name length
        if (fullName.length() < 2 || fullName.length() > 100) {
            setError(request, "Full name must be between 2 and 100 characters.");
            response.sendRedirect(request.getContextPath() + "/auth/register.jsp");
            return;
        }

        // 3. Email format
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            setError(request, "Please enter a valid email address.");
            response.sendRedirect(request.getContextPath() + "/auth/register.jsp");
            return;
        }

        // 4. Password strength: min 8 chars, at least one digit and one letter
        if (password.length() < 8
                || !password.matches(".*[a-zA-Z].*")
                || !password.matches(".*[0-9].*")) {
            setError(request,
                "Password must be at least 8 characters and include both letters and numbers.");
            response.sendRedirect(request.getContextPath() + "/auth/register.jsp");
            return;
        }

        // 5. Confirm password match
        if (!password.equals(confirmPassword)) {
            setError(request, "Passwords do not match.");
            response.sendRedirect(request.getContextPath() + "/auth/register.jsp");
            return;
        }

        // 6. Phone format
        if (!PHONE_PATTERN.matcher(phone).matches()) {
            setError(request, "Please enter a valid 10-digit phone number.");
            response.sendRedirect(request.getContextPath() + "/auth/register.jsp");
            return;
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(password);   // AuthService / PasswordUtil will hash this
        user.setPhone(phone);
        user.setRoleId(1);            // Default: CITIZEN

        try {
            if (authService.register(user)) {
                setSuccess(request, "Registration successful! Please log in.");
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            } else {
                setError(request, "An account with this Email or Phone Number already exists. Please try again.");
                response.sendRedirect(request.getContextPath() + "/auth/register.jsp");
            }
        } catch (RuntimeException e) {
            e.printStackTrace();
            setError(request, "Database connectivity error. Please try again later.");
            response.sendRedirect(request.getContextPath() + "/auth/register.jsp");
        }
    }

    // -----------------------------------------------------------------------
    // LOGOUT
    // -----------------------------------------------------------------------
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Prevent browser from caching the authenticated page after logout
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
    }

    // -----------------------------------------------------------------------
    // Helpers
    // -----------------------------------------------------------------------
    private String trim(String s) { return s == null ? "" : s.trim(); }
    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
    private void setError(HttpServletRequest req, String msg) {
        req.getSession().setAttribute("error", msg);
    }
    private void setSuccess(HttpServletRequest req, String msg) {
        req.getSession().setAttribute("success", msg);
    }
}
