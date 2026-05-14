<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - SRC Fast Food</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #0a0a0a 0%, #1a1a2e 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        /* Admin specific gradient overlay */
        .admin-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at 20% 50%, rgba(228,0,43,0.15) 0%, transparent 50%);
            pointer-events: none;
        }

        .login-container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 450px;
            margin: 20px;
        }

        .login-card {
            background: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(15px);
            border-radius: 30px;
            padding: 50px 40px;
            box-shadow: 0 25px 45px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(228, 0, 43, 0.3);
            transition: 0.3s;
        }

        .login-card:hover {
            border-color: rgba(228, 0, 43, 0.6);
            transform: translateY(-5px);
        }

        .logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #E4002B, #c90026);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 40px;
            box-shadow: 0 0 20px rgba(228, 0, 43, 0.3);
        }

        .logo h2 {
            color: white;
            font-size: 28px;
        }

        .logo p {
            color: #E4002B;
            font-size: 12px;
            letter-spacing: 2px;
        }

        .admin-badge {
            display: inline-block;
            background: rgba(228, 0, 43, 0.2);
            padding: 5px 15px;
            border-radius: 50px;
            font-size: 12px;
            color: #E4002B;
            margin-bottom: 20px;
        }

        .input-group {
            margin-bottom: 25px;
        }

        .input-group label {
            display: block;
            color: #ccc;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .input-field {
            position: relative;
        }

        .input-field i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #E4002B;
        }

        .input-field input {
            width: 100%;
            padding: 15px 15px 15px 45px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            color: white;
            font-size: 16px;
            transition: 0.3s;
        }

        .input-field input:focus {
            outline: none;
            border-color: #E4002B;
            background: rgba(255, 255, 255, 0.1);
        }

        .btn-login {
            width: 100%;
            padding: 15px;
            background: #E4002B;
            border: none;
            border-radius: 15px;
            color: white;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-login:hover {
            background: #c90026;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(228, 0, 43, 0.3);
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #888;
            text-decoration: none;
            font-size: 14px;
        }

        .back-link a:hover {
            color: #E4002B;
        }

        .error {
            background: rgba(220, 53, 69, 0.2);
            border: 1px solid #dc3545;
            color: #dc3545;
            padding: 12px;
            border-radius: 12px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-card {
            animation: fadeInUp 0.6s ease;
        }
    </style>
</head>
<body>
    <div class="admin-overlay"></div>
    
    <div class="login-container">
        <div class="login-card">
            <div class="logo">
                <div class="logo-icon">👑</div>
                <h2>Admin Portal</h2>
                <p>SRC FAST FOOD</p>
                <div class="admin-badge">
                    <i class="fas fa-shield-alt"></i> Secure Access
                </div>
            </div>

            <% if(request.getParameter("error") != null) { %>
                <div class="error">
                    <i class="fas fa-exclamation-triangle"></i> <%= request.getParameter("error") %>
                </div>
            <% } %>

            <form action="AdminAuthServlet" method="post">
                <div class="input-group">
                    <label><i class="fas fa-envelope"></i> Admin Email</label>
                    <div class="input-field">
                        <i class="fas fa-envelope"></i>
                        <input type="email" name="email" placeholder="admin@src.com" required>
                    </div>
                </div>

                <div class="input-group">
                    <label><i class="fas fa-key"></i> Password</label>
                    <div class="input-field">
                        <i class="fas fa-key"></i>
                        <input type="password" name="password" placeholder="Enter password" required>
                    </div>
                </div>

                <button type="submit" class="btn-login">
                    <i class="fas fa-sign-in-alt"></i> Login as Admin
                </button>
            </form>

            <div class="back-link">
                <a href="index.jsp"><i class="fas fa-arrow-left"></i> Back to Home</a>
            </div>
        </div>
    </div>
</body>
</html>