<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ne">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>लगइन - मेरो सरकार</title>
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

    <div class="auth-card">
        <div class="logo-section" style="justify-content: center; margin-bottom: 24px;">
            <img src="images/logo.png" alt="Logo" style="height: 60px;">
        </div>
        <h2>लगइन गर्नुहोस्</h2>
        <p>आफ्नो खातामा प्रवेश गरी गुनासोको स्थिति हेर्नुहोस्।</p>

        <form action="LoginServlet" method="POST">
            <% if(request.getParameter("error") != null) { %>
                <div style="color: red; margin-bottom: 15px;"><%= request.getParameter("error") %></div>
            <% } %>
            <% if(request.getParameter("success") != null) { %>
                <div style="color: green; margin-bottom: 15px;"><%= request.getParameter("success") %></div>
            <% } %>
            <div class="form-group">
                <label for="phone">मोबाइल नम्बर</label>
                <input type="text" id="phone" name="phoneNumber" class="form-control" placeholder="९८XXXXXXXX" required>
            </div>
            <div class="form-group">
                <label for="password">पासवर्ड</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="********" required>
            </div>
            
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <div style="font-size: 0.85rem; color: var(--text-muted);">
                    <input type="checkbox" id="rememberMe" name="rememberMe">
                    <label for="rememberMe" style="display: inline; font-weight: 500;"> मलाई सम्झनुहोस्</label>
                </div>
                <a href="#" style="font-size: 0.85rem; color: var(--gov-blue);">पासवर्ड बिर्सनुभयो?</a>
            </div>

            <button type="submit" class="auth-btn">
                <i class="fas fa-sign-in-alt"></i> लगइन गर्नुहोस्
            </button>
        </form>

        <div class="auth-footer">
            खाता छैन? <a href="register.jsp">नयाँ खाता खोल्नुहोस्</a>
        </div>
    </div>

    </div>
</body>
</html>
