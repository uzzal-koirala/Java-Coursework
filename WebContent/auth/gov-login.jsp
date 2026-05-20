<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta name="description" content="Government User Login - Gunaso Management System. Secure login portal for authorized government officials.">
    <title>Government User Login - Gunaso Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/auth-split.css?v=1.2">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="<%= request.getContextPath() %>/js/script.js" defer></script>
    <style>
        :root {
            --auth-bg: #0a0f1e;
            --card-bg: #0d1b3e;
            --primary-blue: #3b82f6;
            --primary-indigo: #4f46e5;
            --text-dark: #f1f5f9;
            --text-muted: #94a3b8;
            --border-color: rgba(59, 130, 246, 0.15);
            --input-bg: rgba(13, 27, 62, 0.7);
        }

        body {
            background: radial-gradient(ellipse at 30% 20%, #0f1f4a 0%, #050a18 60%, #020510 100%);
            min-height: 100vh;
        }

        /* Animated background blobs */
        .bg-blobs {
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: 0;
            overflow: hidden;
        }

        .blob {
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.18;
            animation: blobFloat 8s ease-in-out infinite alternate;
        }

        .blob-1 {
            width: 520px;
            height: 520px;
            background: radial-gradient(circle, #3b82f6 0%, #1d4ed8 100%);
            top: -150px;
            left: -100px;
        }

        .blob-2 {
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, #4f46e5 0%, #312e81 100%);
            bottom: -100px;
            right: -80px;
            animation-delay: -4s;
        }

        @keyframes blobFloat {
            from { transform: translate(0, 0) scale(1); }
            to   { transform: translate(30px, 20px) scale(1.08); }
        }

        .auth-wrapper {
            border: 1px solid rgba(59, 130, 246, 0.12);
            box-shadow:
                0 25px 60px -12px rgba(0, 0, 0, 0.6),
                0 0 50px rgba(59, 130, 246, 0.06);
            position: relative;
            z-index: 1;
        }

        .auth-form-side {
            background: rgba(10, 15, 30, 0.95);
        }

        .auth-title {
            background: linear-gradient(135deg, #60a5fa 0%, #a5b4fc 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .auth-subtitle {
            color: var(--text-muted);
        }

        /* Gov badge */
        .gov-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(59, 130, 246, 0.1);
            border: 1px solid rgba(59, 130, 246, 0.25);
            border-radius: 100px;
            padding: 6px 14px;
            font-size: 0.75rem;
            font-weight: 700;
            color: #60a5fa;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 16px;
        }

        .gov-badge i {
            font-size: 0.8rem;
        }

        .form-group input {
            color: #f1f5f9;
            background: rgba(15, 25, 55, 0.6);
            border: 1px solid rgba(59, 130, 246, 0.2);
        }

        .form-group input:focus {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }

        .form-group label {
            color: #cbd5e1;
        }

        .password-toggle {
            color: var(--text-muted);
        }

        .remember-me span {
            color: var(--text-muted);
        }

        .btn-submit {
            background: linear-gradient(135deg, #3b82f6 0%, #4f46e5 100%);
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3);
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .btn-submit:hover {
            background: linear-gradient(135deg, #60a5fa 0%, #6366f1 100%);
            box-shadow: 0 6px 22px rgba(59, 130, 246, 0.45);
            transform: translateY(-1px);
        }

        .auth-switch a {
            color: #60a5fa;
        }

        .auth-switch a:hover {
            color: #a5b4fc;
        }

        /* Right image side */
        .auth-image-side {
            background: linear-gradient(160deg, #0d1b3e 0%, #060d24 100%);
            border-left: 1px solid rgba(59, 130, 246, 0.1);
        }

        .auth-image-side h2 {
            background: linear-gradient(135deg, #ffffff 0%, #bfdbfe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .auth-image-side p {
            color: #94a3b8;
        }

        .decorative-square {
            background: rgba(59, 130, 246, 0.06);
            border: 1px solid rgba(59, 130, 246, 0.1);
        }

        .decorative-triangle {
            background: rgba(79, 70, 229, 0.06);
        }

        .image-container {
            border: 1px solid rgba(59, 130, 246, 0.15);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.5), 0 0 30px rgba(59, 130, 246, 0.06);
        }

        .image-container img {
            filter: brightness(0.85) contrast(1.05) saturate(0.9);
        }

        /* Official access notice */
        .official-notice {
            margin-top: 18px;
            padding: 12px 14px;
            background: rgba(59, 130, 246, 0.07);
            border: 1px solid rgba(59, 130, 246, 0.18);
            border-radius: 10px;
            font-size: 0.78rem;
            color: #94a3b8;
            display: flex;
            align-items: flex-start;
            gap: 10px;
            line-height: 1.5;
        }

        .official-notice i {
            color: #60a5fa;
            margin-top: 2px;
            flex-shrink: 0;
        }

        /* Dots */
        .dot.active {
            background: #3b82f6;
        }

        .message-error {
            background: rgba(239, 68, 68, 0.08) !important;
            border: 1px solid rgba(239, 68, 68, 0.2) !important;
            color: #f87171 !important;
        }

        .message-success {
            background: rgba(59, 130, 246, 0.08) !important;
            border: 1px solid rgba(59, 130, 246, 0.2) !important;
            color: #60a5fa !important;
        }
    </style>
</head>
<body>
    <!-- Animated Floating Background Blobs -->
    <div class="bg-blobs">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
    </div>

    <!-- Main Glassmorphic Wrapper -->
    <div class="auth-wrapper">

        <!-- Left Side: Form -->
        <div class="auth-form-side">

            <div class="gov-badge">
                <i class="fa-solid fa-landmark"></i>
                Government Access Portal
            </div>

            <h1 class="auth-title">Government User Login</h1>
            <p class="auth-subtitle">Authorized government officials only. Please use your official credentials.</p>

            <%
                String error = (String) session.getAttribute("error");
                if (error != null) {
            %>
                <div class="message message-error">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <span><%= error %></span>
                </div>
                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        if (typeof showToast === 'function') {
                            showToast('Login Error', '<%= error.replace("'", "\\'") %>', 'error');
                        }
                    });
                </script>
            <%
                    session.removeAttribute("error");
                }

                String success = (String) session.getAttribute("success");
                if (success != null) {
            %>
                <div class="message message-success">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= success %></span>
                </div>
                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        if (typeof showToast === 'function') {
                            showToast('Success', '<%= success.replace("'", "\\'") %>', 'success');
                        }
                    });
                </script>
            <%
                    session.removeAttribute("success");
                }
            %>

            <!-- Login Form -->
            <form action="<%= request.getContextPath() %>/auth/login" method="POST" style="margin-top: 10px;">
                <input type="hidden" name="loginType" value="gov">
                <div class="form-group">
                    <label for="email"><i class="fa-regular fa-envelope" style="margin-right:6px; color:#60a5fa;"></i>Official Email Address</label>
                    <input type="email" id="email" name="email" placeholder="official@gunaso.gov.np" required autocomplete="email">
                </div>

                <div class="form-group">
                    <label for="password"><i class="fa-solid fa-lock" style="margin-right:6px; color:#60a5fa;"></i>Password</label>
                    <input type="password" id="password" name="password" placeholder="••••••••••••••••" required autocomplete="current-password">
                    <i class="fa-regular fa-eye-slash password-toggle" id="pwdToggle" onclick="togglePassword()"></i>
                </div>

                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember">
                        <span>Keep me signed in</span>
                    </label>
                </div>

                <button type="submit" id="govLoginBtn" class="btn-submit">
                    <i class="fa-solid fa-right-to-bracket" style="margin-right: 8px;"></i>Access Portal
                </button>
            </form>

            <div class="official-notice">
                <i class="fa-solid fa-shield-halved"></i>
                <span>This portal is exclusively for authorized government officials (Ward Officers, Municipal Heads, and affiliated personnel). Unauthorized access attempts are logged and reported.</span>
            </div>

            <div class="auth-switch">
                Citizen? <a href="<%= request.getContextPath() %>/auth/login.jsp">Sign in to Citizen Portal</a>
            </div>
        </div>

        <!-- Right Side: Decorative Image -->
        <div class="auth-image-side">
            <div class="decorative-square"></div>
            <div class="decorative-triangle"></div>

            <div class="image-container">
                <img src="<%= request.getContextPath() %>/images/balen-gov.jpg" alt="Government of Nepal Official">
            </div>

            <h2>Serve with Accountability.</h2>
            <p>Welcome to the Gunaso Government Portal. Manage citizen grievances, track complaints, and deliver transparent, timely responses to the people you serve.</p>

            <div class="pagination">
                <div class="dot active"></div>
                <div class="dot"></div>
                <div class="dot"></div>
            </div>
        </div>

    </div>

    <script>
        function togglePassword() {
            const input = document.getElementById('password');
            const icon  = document.getElementById('pwdToggle');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            } else {
                input.type = 'password';
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            }
        }
    </script>
</body>
</html>
