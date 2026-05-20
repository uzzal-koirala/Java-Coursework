<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrative Terminal - Gunaso Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/auth-split.css?v=1.1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="<%= request.getContextPath() %>/js/script.js?v=1.1" defer></script>
    <style>
        :root {
            --auth-bg: #090d16;
            --card-bg: #0f172a;
            --primary-blue: #10b981; /* Emerald green theme for Super Admin */
            --text-dark: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: rgba(255, 255, 255, 0.1);
            --input-bg: rgba(15, 23, 42, 0.6);
        }

        body {
            background: radial-gradient(circle at 50% 50%, #111827 0%, #030712 100%);
        }

        .auth-wrapper {
            border: 1px solid rgba(255, 255, 255, 0.05);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5),
                        0 0 40px rgba(16, 185, 129, 0.03);
        }

        .auth-image-side {
            background: #090d16;
            border-left: 1px solid rgba(255, 255, 255, 0.05);
        }

        .form-group input {
            color: #f8fafc;
            background: var(--input-bg);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .form-group input:focus {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.15);
        }

        .password-toggle {
            color: var(--text-muted);
        }

        .remember-me span {
            color: var(--text-muted);
        }

        .btn-submit {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.2);
        }

        .btn-submit:hover {
            background: linear-gradient(135deg, #34d399 0%, #10b981 100%);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.35);
        }

        .auth-image-side h2 {
            background: linear-gradient(135deg, #ffffff 0%, #cbd5e1 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .decorative-square, .decorative-triangle {
            background: rgba(255, 255, 255, 0.05);
        }

        .image-container {
            border: 1px solid rgba(255, 255, 255, 0.05);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.6);
        }

        .image-container img {
            filter: brightness(0.8) contrast(1.1);
        }
    </style>
</head>
<body>
    <div class="auth-wrapper">
        <!-- Left Side: Form -->
        <div class="auth-form-side">
            <h1 class="auth-title">Administrative Terminal</h1>
            <p class="auth-subtitle">Welcome back, Super Admin! Please log in.</p>

            <% 
                String error = (String) session.getAttribute("error");
                if (error != null) {
            %>
                <div class="message message-error" style="background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.2); color: #f87171;"><%= error %></div>
                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        showToast('Access Error', '<%= error.replace("'", "\\'") %>', 'error');
                    });
                </script>
            <% 
                    session.removeAttribute("error");
                }
            %>

            <% 
                String success = (String) session.getAttribute("success");
                if (success != null) {
            %>
                <div class="message message-success" style="background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.2); color: #34d399;"><%= success %></div>
                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        showToast('Terminal Success', '<%= success.replace("'", "\\'") %>', 'success');
                    });
                </script>
            <% 
                    session.removeAttribute("success");
                }
            %>

            <form action="<%= request.getContextPath() %>/auth/login" method="POST" style="margin-top: 15px;">
                <input type="hidden" name="loginType" value="superadmin">
                
                <div class="form-group">
                    <label for="email">Clearance ID (Email)</label>
                    <input type="email" id="email" name="email" placeholder="admin@gunaso.gov.np" required autocomplete="off">
                </div>
                <div class="form-group">
                    <label for="password">Security Cipher (Password)</label>
                    <input type="password" id="password" name="password" placeholder="*****************" required>
                    <i class="fa-regular fa-eye-slash password-toggle" onclick="togglePassword('password', this)"></i>
                </div>
                
                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember">
                        <span>Remember clearance</span>
                    </label>
                </div>

                <button type="submit" class="btn-submit" style="margin-top: 10px;">Authenticate Session</button>
            </form>

            <div class="auth-switch">
                Return to <a href="<%= request.getContextPath() %>/auth/login.jsp">Citizen Portal</a>
            </div>
        </div>

        <!-- Right Side: Decorative Image -->
        <div class="auth-image-side">
            <div class="decorative-square"></div>
            <div class="decorative-triangle"></div>
            <div class="image-container">
                <img src="<%= request.getContextPath() %>/images/balen-gov.jpg" alt="Administrative Node">
            </div>
            <h2>Root Clearance Console.</h2>
            <p>You are accessing the secure administrative terminal of the Gunaso Grievance Portal. Please ensure all actions align with official regulatory guidelines.</p>
            
            <div class="pagination">
                <div class="dot active"></div>
                <div class="dot"></div>
                <div class="dot"></div>
            </div>
        </div>
    </div>
    
    <script>
        function togglePassword(inputId, icon) {
            const input = document.getElementById(inputId);
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            }
        }
    </script>
</body>
</html>
