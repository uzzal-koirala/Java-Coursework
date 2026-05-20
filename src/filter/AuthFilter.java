package filter;

import model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AuthFilter – intercepts every request and enforces authentication.
 *
 * Public paths (no login needed):
 *   /            – root redirect
 *   /index.jsp   – home page
 *   /about.jsp   – about page
 *   /contact.jsp – contact page
 *   /auth/*      – login, register pages and endpoints
 *   /css/*       – stylesheets
 *   /js/*        – scripts
 *   /images/*    – images
 *
 * Everything else requires a valid session with a "user" attribute.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  httpRequest  = (HttpServletRequest)  request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String ctx = httpRequest.getContextPath();
        String uri = httpRequest.getRequestURI();

        // Check session
        HttpSession session  = httpRequest.getSession(false);
        boolean     loggedIn = session != null && session.getAttribute("user") != null;

        // -----------------------------------------------------------------------
        // Build the public-access whitelist
        // -----------------------------------------------------------------------
        boolean isPublic =
            // Static resources
            uri.startsWith(ctx + "/css/")        ||
            uri.startsWith(ctx + "/js/")         ||
            uri.startsWith(ctx + "/images/")     ||
            uri.startsWith(ctx + "/uploads/")    ||
            // Auth pages and endpoints
            uri.startsWith(ctx + "/auth/")       ||
            // Standalone government login portal (root level)
            uri.equals(ctx + "/gov-portal.jsp")  ||
            // Public info pages (available without login)
            uri.equals(ctx + "/")                ||
            uri.equals(ctx + "/index.jsp")       ||
            uri.equals(ctx + "/about.jsp")       ||
            uri.equals(ctx + "/contact.jsp");

        // -----------------------------------------------------------------------
        // Security headers — applied to every response
        // -----------------------------------------------------------------------
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        httpResponse.setHeader("X-Frame-Options",        "SAMEORIGIN");
        httpResponse.setHeader("X-XSS-Protection",      "1; mode=block");

        if (loggedIn || isPublic) {
            // If the user is already logged in and tries to visit login/register,
            // redirect them to their dashboard instead.
            if (loggedIn && uri.startsWith(ctx + "/auth/")
                    && (uri.contains("login") || uri.contains("register"))) {
                User sessionUser = (User) session.getAttribute("user");
                String role = sessionUser != null ? sessionUser.getRoleName() : null;
                if (role != null && !"CITIZEN".equalsIgnoreCase(role) && !"SUPER_ADMIN".equalsIgnoreCase(role)) {
                    httpResponse.sendRedirect(ctx + "/gov-dashboard");
                } else {
                    httpResponse.sendRedirect(ctx + "/dashboard");
                }
                return;
            }
            // Also redirect logged-in gov officials away from gov-portal.jsp
            if (loggedIn && uri.equals(ctx + "/gov-portal.jsp")) {
                User sessionUser = (User) session.getAttribute("user");
                String role = sessionUser != null ? sessionUser.getRoleName() : null;
                if (role != null && !"CITIZEN".equalsIgnoreCase(role) && !"SUPER_ADMIN".equalsIgnoreCase(role)) {
                    httpResponse.sendRedirect(ctx + "/gov-dashboard");
                    return;
                }
            }
            chain.doFilter(request, response);
        } else {
            // Determine correct portal redirect for unauthenticated users
            httpResponse.sendRedirect(ctx + "/auth/login.jsp");
        }
    }

    @Override
    public void destroy() {}
}
