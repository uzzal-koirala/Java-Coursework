<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Gunaso Management System</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/auth-split.css?v=1.2">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="<%= request.getContextPath() %>/js/script.js?v=1.2" defer></script>
</head>
<body>
    <!-- Animated Floating Background Blobs -->
    <div class="bg-blobs">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
    </div>

    <!-- Main Glassmorphic Wrapper in Reverse Order -->
    <div class="auth-wrapper reverse">
        
        <!-- Form Panel (Visually on the Right) -->
        <div class="auth-form-side">
            <h1 class="auth-title">Create an account</h1>
            <p class="auth-subtitle">Have an account already? <a href="login.jsp" style="color: var(--primary-light); font-weight: 700; text-decoration: none;">Login here</a></p>

            <!-- Social Authentication Options -->
            <div class="social-login">
                <a href="javascript:void(0);" class="btn-social" onclick="showToast('Social Auth', 'Google signup is currently locked in development.', 'error');">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg" alt="Google">
                    Sign up with Google
                </a>
                <a href="javascript:void(0);" class="btn-social" onclick="showToast('Social Auth', 'Apple signup is currently locked in development.', 'error');">
                    <i class="fa-brands fa-apple" style="font-size:1.25rem; color:#000;"></i>
                    Sign up with Apple
                </a>
            </div>

            <!-- Visual Divider -->
            <div class="divider">Or register with email</div>

            <!-- Session Notifications (Inline Alerts & Toasts) -->
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
                            showToast('Registration Error', '<%= error.replace("'", "\\'") %>', 'error');
                        }
                    });
                </script>
            <% 
                    session.removeAttribute("error");
                }
            %>

            <!-- Registration Form -->
            <form action="<%= request.getContextPath() %>/auth/register" method="POST">
                <!-- Dual Grid Inputs for Full Name and Phone to optimize spacing -->
                <div style="display: flex; gap: 16px;">
                    <div class="form-group" style="flex: 1;">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" placeholder="John Doe" required autocomplete="name">
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" name="phone" placeholder="98XXXXXXXX" required autocomplete="tel">
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="johndoe@gmail.com" required autocomplete="email">
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="••••••••••••••••" required autocomplete="new-password">
                    <i class="fa-regular fa-eye-slash password-toggle" id="pwdToggle" onclick="togglePassword('password', this)"></i>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••••••••••••" required autocomplete="new-password">
                    <i class="fa-regular fa-eye-slash password-toggle" id="confirmPwdToggle" onclick="togglePassword('confirmPassword', this)"></i>
                </div>

                <button type="submit" class="btn-submit" style="margin-top: 10px;">Create Account</button>
            </form>
        </div>

        <!-- Left Side: Blue Hero Split-Screen Illustration (Visually on the Left) -->
        <div class="auth-image-side">
            <!-- Subtle Geometric Background Shapes -->
            <div class="decorative-square"></div>
            <div class="decorative-triangle"></div>

            <h2 style="font-size: 1.8rem; text-align: left; align-self: flex-start;">Make your civic life easier.</h2>
            
            <!-- Prominent Dynamic Image -->
            <div class="image-container" style="box-shadow: none; background: transparent; padding: 0; max-width: 410px; margin-bottom: 20px;">
                <img src="<%= request.getContextPath() %>/images/balensapat.png" alt="Citizen & Authority Interaction" style="opacity: 0.95; height: 260px; object-fit: contain;">
            </div>

            <!-- Premium Testimonial Card -->
            <div class="testimonial-card">
                <p class="testimonial-text">"Such a wonderful platform that's easy to use and work with. Transparent status tracking gives citizens real empowerment!"</p>
                <div class="testimonial-author">
                    <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Sujal Bardewa" class="author-avatar">
                    <div class="author-info">
                        <h4>Sujal Bardewa</h4>
                        <span>Active Citizen</span>
                    </div>
                </div>
            </div>

            <!-- Page Indicators -->
            <div class="pagination" style="margin-top: 30px;">
                <div class="dot" onclick="showToast('Info', 'Civic services overview page.', 'success');"></div>
                <div class="dot active"></div>
                <div class="dot" onclick="showToast('Info', 'State regulations guidelines page.', 'success');"></div>
            </div>
        </div>

    </div>

    <!-- Password Mask/Unmask Toggle Controller -->
    <script>
        function togglePassword(inputId, icon) {
            const input = document.getElementById(inputId);
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