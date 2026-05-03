<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ne">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>दर्ता - मेरो सरकार</title>
    <link rel="stylesheet" href="css/style.css?v=<%= System.currentTimeMillis() %>">
    <style>
        /* Embedded styles to guarantee centering regardless of external CSS loading issues */
        html, body {
            height: 100% !important;
            margin: 0 !important;
            padding: 0 !important;
            overflow: hidden;
        }
        .auth-page {
            width: 100vw !important;
            height: 100vh !important;
            display: flex !important;
            justify-content: center !important;
            align-items: center !important;
            background: linear-gradient(135deg, #e0e7ff 0%, #f1f5f9 100%) !important;
        }
        .auth-card {
            margin: auto !important;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="auth-page">

    <a href="index.jsp" class="back-home">
        <i class="fas fa-arrow-left"></i> गृहपृष्ठमा फर्कनुहोस्
    </a>

    <div class="auth-card" style="max-width: 500px;">
        <div class="logo-section" style="justify-content: center; margin-bottom: 24px;">
            <img src="images/logo.png" alt="Logo" style="height: 60px;">
        </div>
        <h2>नयाँ खाता खोल्नुहोस्</h2>
        <p>नागरिक पोर्टलमा आबद्ध हुन आफ्नो विवरण भर्नुहोस्।</p>

        <form action="RegisterServlet" method="POST" enctype="multipart/form-data">
            <% if(request.getParameter("error") != null) { %>
                <div style="color: red; margin-bottom: 15px;"><%= request.getParameter("error") %></div>
            <% } %>
            <div class="form-row">
                <div class="form-group">
                    <label for="fullname">पूरा नाम (Full Name)</label>
                    <input type="text" id="fullname" name="fullName" class="form-control" placeholder="उदा. राम बहादुर थापा" required>
                </div>
                <div class="form-group">
                    <label for="phone">मोबाइल नम्बर (Mobile Number)</label>
                    <input type="text" id="phone" name="phoneNumber" class="form-control" placeholder="९८XXXXXXXX" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="password">पासवर्ड (Password)</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="********" required>
                </div>
                <div class="form-group">
                    <label for="confirm_password">पासवर्ड पुन: टाइप गर्नुहोस्</label>
                    <input type="password" id="confirm_password" name="confirm_password" class="form-control" placeholder="********" required>
                </div>
            </div>

            <div class="form-group">
                <label for="profilePic">प्रोफाइल तस्वीर (Profile Picture)</label>
                <div class="file-upload-wrapper">
                    <input type="file" id="profilePic" name="profilePic" class="file-upload-input" accept="image/*">
                    <div class="file-upload-design">
                        <i class="fas fa-cloud-upload-alt"></i>
                        <span>तस्वीर चयन गर्नुहोस् वा यहाँ तान्नुहोस्</span>
                        <p>JPG, PNG (Max 2MB)</p>
                    </div>
                </div>
            </div>

            <div style="text-align: left; margin-bottom: 24px; font-size: 0.85rem; color: var(--text-muted);">
                <input type="checkbox" id="terms" required>
                <label for="terms" style="display: inline; font-weight: 500;"> म <a href="#" style="color: var(--gov-blue);">नियम र सर्तहरू</a> पालना गर्न सहमत छु।</label>
            </div>

            <button type="submit" class="auth-btn">
                <i class="fas fa-user-plus"></i> खाता सिर्जना गर्नुहोस्
            </button>
        </form>

        <div class="auth-footer">
            पहिले नै खाता छ? <a href="login.jsp">लगइन गर्नुहोस्</a>
        </div>
    </div>

    </div>
</body>
</html>
