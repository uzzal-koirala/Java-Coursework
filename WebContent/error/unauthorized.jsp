<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unauthorized Access - Gunaso Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="auth-container">
        <div class="auth-header">
            <h1 style="color: #e74c3c;">Access Denied</h1>
            <p>You do not have permission to access this page.</p>
        </div>
        <div style="text-align: center; margin-top: 20px;">
            <a href="<%= request.getContextPath() %>/dashboard" class="btn">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
