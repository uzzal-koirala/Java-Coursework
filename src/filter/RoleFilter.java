package filter;

import model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter({"/user/*", "/admin/*", "/superadmin/*"})
public class RoleFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = user.getRoleName();
        String uri = httpRequest.getRequestURI();

        boolean authorized = false;

        if ("SUPER_ADMIN".equals(role)) {
            authorized = true;
        } else if (uri.contains("/user/")) {
            if ("CITIZEN".equals(role) || "WADA_ADAKSHYA".equals(role) || "NAGAR_PRAMUKH".equals(role) || "PRIME_MINISTER".equals(role)) {
                authorized = true;
            }
        } else if (uri.contains("/superadmin/") && "SUPER_ADMIN".equals(role)) {
            authorized = true;
        } else if (uri.contains("/admin/")) {
            if ("WADA_ADAKSHYA".equals(role) || "NAGAR_PRAMUKH".equals(role) || "PRIME_MINISTER".equals(role)) {
                authorized = true;
            }
        }

        if (authorized) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/error/unauthorized.jsp");
        }
    }

    @Override
    public void destroy() {}
}
