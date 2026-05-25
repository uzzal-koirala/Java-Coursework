<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <title>Sign In - Gunaso Management System</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/auth-split.css?v=1.2">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="<%= request.getContextPath() %>/js/script.js" defer></script>
</head>
<body>
    <!-- Animated Floating Background Blobs -->
    <div class="bg-blobs">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
    </div>

    <!-- Main Glassmorphic Wrapper -->
    <div class="auth-wrapper">
        
        <div class="auth-form-side">
            <h1 class="auth-title">Sign in to proceed</h1>
            <p class="auth-subtitle">Welcome back! Please enter your credentials to log in.</p>

            <!-- Social Authentication Options -->
            <div class="social-login">
                <a href="javascript:void(0);" class="btn-social" onclick="showToast('Social Auth', 'Google authentication is currently locked in development.', 'error');">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg" alt="Google">
                    Sign in with Google
                </a>
                <a href="javascript:void(0);" class="btn-social" onclick="showToast('Social Auth', 'Apple authentication is currently locked in development.', 'error');">
                    <i class="fa-brands fa-apple" style="font-size:1.25rem; color:#000;"></i>
                    Sign in with Apple
                </a>
            </div>

            <!-- Visual Divider -->
            <div class="divider">Or with email</div>

            <!-- Session Notifications (Toasts & Inline Alerts) -->
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
            <form action="<%= request.getContextPath() %>/auth/login" method="POST">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="johndoe@gmail.com" required autocomplete="email">
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="••••••••••••••••" required autocomplete="current-password">
                    <i class="fa-regular fa-eye-slash password-toggle" id="pwdToggle" onclick="togglePassword()"></i>
                </div>

                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember">
                        <span>Remember me</span>
                    </label>
                    <a href="javascript:void(0);" class="forgot-password" onclick="showToast('Password Recovery', 'Please contact your departmental admin or click standard recovery options in development.', 'error');">Forgot Password?</a>
                </div>

                <button type="submit" class="btn-submit">Sign In</button>
            </form>

            <div class="auth-switch" style="margin-top: 15px;">
                Don't have an account? <a href="register.jsp">Sign Up</a>
            </div>
        </div>

        <!-- Right Side: Blue Hero Split-Screen Illustration -->
        <div class="auth-image-side">
            <!-- Subtle Geometric Background Shapes -->
            <div class="decorative-square"></div>
            <div class="decorative-triangle"></div>

            <!-- Prominent Dynamic Image -->
            <div class="image-container">
                <img src="<%= request.getContextPath() %>/images/balen-gov.jpg" alt="Civic Grievance Meeting">
            </div>

            <h2>Simplify your civic engagement.</h2>
            <p>Gunaso Management System is Nepal's official portal where you can easily submit, track, and resolve complaints with relevant local and state authorities.</p>

            <!-- Premium Testimonial Card -->
            <div class="testimonial-card">
                <p class="testimonial-text">"This platform has completely transformed how we voice our community issues. Responsive, modern, and transparent!"</p>
                <div class="testimonial-author">
                    <img src="https://randomuser.me/api/portraits/women/44.jpg" alt="Aaradhya Joshi" class="author-avatar">
                    <div class="author-info">
                        <h4>Aaradhya Joshi</h4>
                        <span>Kathmandu Resident</span>
                    </div>
                </div>
            </div>

            <!-- Page Indicators -->
            <div class="pagination">
                <div class="dot active"></div>
                <div class="dot" onclick="showToast('Info', 'Civic services overview page.', 'success');"></div>
                <div class="dot" onclick="showToast('Info', 'State regulations guidelines page.', 'success');"></div>
            </div>
        </div>

    </div>

    <!-- Password Mask/Unmask Toggle Controller -->
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
//done by DWEEP