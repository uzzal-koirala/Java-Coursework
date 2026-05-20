<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <title>Government User Login - Gunaso Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: radial-gradient(ellipse at 30% 20%, #0f1f4a 0%, #050a18 60%, #020510 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        /* Animated background blobs */
        .bg-blob {
            position: fixed;
            border-radius: 50%;
            filter: blur(90px);
            opacity: 0.15;
            pointer-events: none;
            animation: float 9s ease-in-out infinite alternate;
        }
        .blob-1 {
            width: 520px; height: 520px;
            background: radial-gradient(circle, #3b82f6, #1d4ed8);
            top: -160px; left: -120px;
        }
        .blob-2 {
            width: 420px; height: 420px;
            background: radial-gradient(circle, #6366f1, #312e81);
            bottom: -120px; right: -100px;
            animation-delay: -4s;
        }
        @keyframes float {
            from { transform: translate(0,0) scale(1); }
            to   { transform: translate(25px, 18px) scale(1.07); }
        }

        /* Card wrapper */
        .auth-card {
            background: rgba(8, 14, 35, 0.96);
            border: 1px solid rgba(59, 130, 246, 0.15);
            border-radius: 24px;
            box-shadow: 0 30px 70px rgba(0,0,0,0.6), 0 0 60px rgba(59,130,246,0.05);
            display: flex;
            width: 900px;
            max-width: 96vw;
            min-height: 520px;
            position: relative;
            z-index: 1;
            overflow: hidden;
        }

        /* Left — Form */
        .form-side {
            flex: 1;
            padding: 50px 45px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .gov-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(59,130,246,0.1);
            border: 1px solid rgba(59,130,246,0.25);
            border-radius: 100px;
            padding: 6px 16px;
            font-size: 0.73rem;
            font-weight: 700;
            color: #60a5fa;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            margin-bottom: 18px;
            width: fit-content;
        }

        h1 {
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, #60a5fa 0%, #a5b4fc 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }

        .subtitle {
            font-size: 0.92rem;
            color: #64748b;
            margin-bottom: 32px;
            line-height: 1.5;
        }

        /* Alert messages */
        .msg-error {
            background: rgba(239,68,68,0.1);
            border: 1px solid rgba(239,68,68,0.25);
            color: #f87171;
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 0.88rem;
            display: flex;
            align-items: center;
            gap: 9px;
            margin-bottom: 20px;
        }

        /* Form inputs */
        .field {
            margin-bottom: 20px;
            position: relative;
        }
        .field label {
            display: block;
            font-size: 0.84rem;
            font-weight: 600;
            color: #94a3b8;
            margin-bottom: 8px;
        }
        .field input {
            width: 100%;
            padding: 13px 16px;
            border-radius: 12px;
            border: 1px solid rgba(59,130,246,0.2);
            background: rgba(15,25,55,0.6);
            color: #f1f5f9;
            font-size: 0.95rem;
            outline: none;
            transition: border-color 0.25s, box-shadow 0.25s;
        }
        .field input:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.12);
        }
        .field input::placeholder { color: #334155; }

        /* Toggle password */
        .eye-icon {
            position: absolute;
            right: 14px;
            top: 42px;
            color: #475569;
            cursor: pointer;
            font-size: 0.95rem;
            transition: color 0.2s;
        }
        .eye-icon:hover { color: #94a3b8; }

        /* Submit button */
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #3b82f6 0%, #4f46e5 100%);
            color: #ffffff;
            font-size: 0.98rem;
            font-weight: 700;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            box-shadow: 0 5px 18px rgba(59,130,246,0.35);
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            margin-top: 8px;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 26px rgba(59,130,246,0.45);
        }
        .btn-login:active { transform: translateY(0); }

        .notice {
            margin-top: 22px;
            padding: 12px 14px;
            background: rgba(59,130,246,0.06);
            border: 1px solid rgba(59,130,246,0.15);
            border-radius: 10px;
            font-size: 0.78rem;
            color: #64748b;
            display: flex;
            align-items: flex-start;
            gap: 9px;
            line-height: 1.55;
        }
        .notice i { color: #60a5fa; flex-shrink: 0; margin-top: 2px; }

        .back-link {
            text-align: center;
            margin-top: 18px;
            font-size: 0.84rem;
            color: #475569;
        }
        .back-link a {
            color: #60a5fa;
            text-decoration: none;
            font-weight: 600;
        }
        .back-link a:hover { color: #93c5fd; }

        /* Right — Decorative panel */
        .deco-side {
            width: 340px;
            background: linear-gradient(160deg, #0d1b3e 0%, #060d24 100%);
            border-left: 1px solid rgba(59,130,246,0.08);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 30px;
            text-align: center;
        }

        .deco-icon-wrap {
            width: 90px; height: 90px;
            background: rgba(59,130,246,0.1);
            border: 1px solid rgba(59,130,246,0.2);
            border-radius: 22px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.2rem;
            color: #60a5fa;
            margin-bottom: 28px;
            box-shadow: 0 0 40px rgba(59,130,246,0.1);
        }

        .deco-side h2 {
            font-size: 1.45rem;
            font-weight: 800;
            background: linear-gradient(135deg, #ffffff 0%, #bfdbfe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 14px;
            line-height: 1.3;
        }

        .deco-side p {
            font-size: 0.88rem;
            color: #475569;
            line-height: 1.6;
        }

        .deco-divider {
            width: 50px; height: 2px;
            background: linear-gradient(90deg, #3b82f6, #6366f1);
            border-radius: 2px;
            margin: 22px auto;
        }

        .deco-stat {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(59,130,246,0.07);
            border: 1px solid rgba(59,130,246,0.12);
            border-radius: 12px;
            padding: 11px 16px;
            margin-top: 12px;
            width: 100%;
            text-align: left;
        }
        .deco-stat i { color: #60a5fa; font-size: 1rem; }
        .deco-stat span { font-size: 0.8rem; color: #64748b; }

        @media (max-width: 700px) {
            .deco-side { display: none; }
            .form-side { padding: 38px 28px; }
            h1 { font-size: 1.6rem; }
        }
    </style>
</head>
<body>
    <!-- Animated blobs -->
    <div class="bg-blob blob-1"></div>
    <div class="bg-blob blob-2"></div>

    <div class="auth-card">

        <!-- ===== LEFT: LOGIN FORM ===== -->
        <div class="form-side">

            <div class="gov-badge">
                <i class="fa-solid fa-landmark"></i>
                Government Access Portal
            </div>

            <h1>Government User Login</h1>
            <p class="subtitle">Authorized government officials only.<br>Please use your official credentials to access the portal.</p>

            <%
                String error = (String) session.getAttribute("error");
                if (error != null) {
                    session.removeAttribute("error");
            %>
                <div class="msg-error">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <%= error %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/auth/login" method="POST">
                <input type="hidden" name="loginType" value="gov">

                <div class="field">
                    <label for="email"><i class="fa-regular fa-envelope" style="margin-right:5px; color:#60a5fa;"></i>Official Email Address</label>
                    <input type="email" id="email" name="email" placeholder="official@gunaso.gov.np" required autocomplete="off">
                </div>

                <div class="field">
                    <label for="password"><i class="fa-solid fa-lock" style="margin-right:5px; color:#60a5fa;"></i>Password</label>
                    <input type="password" id="password" name="password" placeholder="••••••••••••••" required>
                    <i class="fa-regular fa-eye-slash eye-icon" id="eyeIcon" onclick="togglePwd()"></i>
                </div>

                <button type="submit" class="btn-login">
                    <i class="fa-solid fa-right-to-bracket"></i>
                    Access Government Portal
                </button>
            </form>

            <div class="notice">
                <i class="fa-solid fa-shield-halved"></i>
                <span>This portal is exclusively for authorized government officials. Unauthorized access attempts are logged and reported to security administrators.</span>
            </div>

            <div class="back-link">
                Citizen? <a href="<%= request.getContextPath() %>/auth/login.jsp">Sign in to Citizen Portal</a>
            </div>
        </div>

        <!-- ===== RIGHT: DECORATIVE PANEL ===== -->
        <div class="deco-side">
            <div class="deco-icon-wrap">
                <i class="fa-solid fa-landmark"></i>
            </div>

            <h2>Serve with Accountability</h2>
            <p>Welcome to the Gunaso Government Portal. Manage citizen grievances and deliver transparent, timely responses.</p>

            <div class="deco-divider"></div>

            <div class="deco-stat">
                <i class="fa-solid fa-list-check"></i>
                <span>Review &amp; resolve department complaints</span>
            </div>
            <div class="deco-stat">
                <i class="fa-solid fa-bullhorn"></i>
                <span>Broadcast official announcements</span>
            </div>
            <div class="deco-stat">
                <i class="fa-solid fa-shield-halved"></i>
                <span>Secured &amp; encrypted connection</span>
            </div>
        </div>

    </div>

    <script>
        function togglePwd() {
            const input = document.getElementById('password');
            const icon  = document.getElementById('eyeIcon');
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
