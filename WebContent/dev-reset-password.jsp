<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBConnection, util.PasswordUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dev: Reset Password</title>
    <style>
        body { font-family: monospace; background:#1e1e1e; color:#0f0; padding: 30px; }
        input, button { padding: 8px 14px; margin: 6px 0; font-size:14px; display:block; }
        .ok { color: #4f4; }
        .err { color: #f44; }
        .box { background:#2a2a2a; padding:20px; border-radius:8px; max-width:500px; }
    </style>
</head>
<body>
<div class="box">
    <h2>🔧 DEV — Reset User Password</h2>
    <p style="color:#aaa;font-size:12px;">⚠ Remove this file before going to production!</p>
    <hr style="border-color:#444;">

    <%
        String msg = "";
        String resultClass = "";

        String email    = request.getParameter("email");
        String newPass  = request.getParameter("newPass");

        if (email != null && newPass != null && !email.isEmpty() && !newPass.isEmpty()) {
            try {
                String hashed = PasswordUtil.hashPassword(newPass);
                String sql = "UPDATE users SET password = ? WHERE email = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, hashed);
                    ps.setString(2, email);
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        msg = "✅ Password reset for: " + email + " → New password: " + newPass;
                        resultClass = "ok";
                    } else {
                        msg = "❌ No user found with email: " + email;
                        resultClass = "err";
                    }
                }
            } catch (Exception e) {
                msg = "❌ Error: " + e.getMessage();
                resultClass = "err";
            }
        }
    %>

    <% if (!msg.isEmpty()) { %>
        <p class="<%= resultClass %>"><%= msg %></p>
    <% } %>

    <form method="post">
        <label>Email:</label>
        <input type="email" name="email" value="<%= email != null ? email : "" %>" placeholder="citizen@gmail.com">
        <label>New Password:</label>
        <input type="text" name="newPass" value="" placeholder="min 8 chars, letters+numbers">
        <button type="submit">Reset Password</button>
    </form>

    <hr style="border-color:#444; margin-top:20px;">
    <h3>Existing Users</h3>
    <%
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT u.email, r.role_name, u.status FROM users u JOIN roles r ON u.role_id = r.id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
    %>
        <p><%= rs.getString("email") %> — <b><%= rs.getString("role_name") %></b> [<%= rs.getString("status") %>]</p>
    <%
            }
        } catch (Exception e) {
            out.println("<p class='err'>DB Error: " + e.getMessage() + "</p>");
        }
    %>
</div>
</body>
</html>
