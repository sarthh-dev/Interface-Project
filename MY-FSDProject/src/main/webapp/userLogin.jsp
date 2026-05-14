<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Login - SRC Fast Food</title>
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
            overflow-x: hidden;
        }

        /* Animated Background */
        .bg-animation {
            position: fixed;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: 0;
        }

        .circle {
            position: absolute;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(228,0,43,0.1) 0%, transparent 70%);
            animation: float 20s infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0) translateX(0); }
            25% { transform: translateY(-50px) translateX(50px); }
            50% { transform: translateY(0) translateX(100px); }
            75% { transform: translateY(50px) translateX(50px); }
        }

        /* Login Container */
        .login-container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 450px;
            margin: 20px;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 30px;
            padding: 50px 40px;
            box-shadow: 0 25px 45px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: 0.3s;
        }

        .login-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 50px rgba(0, 0, 0, 0.3);
        }

        .logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #E4002B, #FFC72C);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 45px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .logo h2 {
            color: white;
            font-size: 28px;
        }

        .logo p {
            color: #888;
            font-size: 12px;
        }

        .input-group {
            margin-bottom: 25px;
        }

        .input-group label {
            display: block;
            color: #ccc;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 500;
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
            font-size: 18px;
        }

        .input-field input {
            width: 100%;
            padding: 15px 15px 15px 45px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            color: white;
            font-size: 16px;
            transition: 0.3s;
        }

        .input-field input:focus {
            outline: none;
            border-color: #E4002B;
            background: rgba(255, 255, 255, 0.15);
        }

        .options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .remember {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #ccc;
            font-size: 14px;
        }

        .forgot {
            color: #E4002B;
            text-decoration: none;
            font-size: 14px;
        }

        .btn-login {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #E4002B, #c90026);
            border: none;
            border-radius: 15px;
            color: white;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(228, 0, 43, 0.3);
        }

        .signup-link {
            text-align: center;
            margin-top: 25px;
            color: #888;
        }

        .signup-link a {
            color: #E4002B;
            text-decoration: none;
            font-weight: 600;
        }

        .error {
            background: rgba(220, 53, 69, 0.2);
            border: 1px solid #dc3545;
            color: #dc3545;
            padding: 10px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-card {
            animation: fadeIn 0.6s ease;
        }
    </style>
</head>
<body>
    <div class="bg-animation">
        <div class="circle" style="width: 300px; height: 300px; top: -150px; left: -150px; animation-duration: 25s;"></div>
        <div class="circle" style="width: 500px; height: 500px; bottom: -250px; right: -250px; animation-duration: 30s;"></div>
        <div class="circle" style="width: 200px; height: 200px; top: 50%; left: 50%; animation-duration: 20s;"></div>
    </div>

    <div class="login-container">
        <div class="login-card">
            <div class="logo">
                <div class="logo-icon">🍔</div>
                <h2>Welcome Back!</h2>
                <p>Login to continue your food journey</p>
            </div>

            <% if(request.getParameter("error") != null) { %>
                <div class="error">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getParameter("error") %>
                </div>
            <% } %>

            <form action="UserAuthServlet" method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="input-group">
                    <label><i class="fas fa-envelope"></i> Email Address</label>
                    <div class="input-field">
                        <i class="fas fa-envelope"></i>
                        <input type="email" name="email" placeholder="Enter your email" required>
                    </div>
                </div>

                <div class="input-group">
                    <label><i class="fas fa-lock"></i> Password</label>
                    <div class="input-field">
                        <i class="fas fa-lock"></i>
                        <input type="password" name="password" placeholder="Enter your password" required>
                    </div>
                </div>

                <div class="options">
                    <label class="remember">
                        <input type="checkbox"> Remember Me
                    </label>
                    <a href="#" class="forgot">Forgot Password?</a>
                </div>

                <button type="submit" class="btn-login">
                    <i class="fas fa-arrow-right"></i> Login
                </button>
            </form>

            <div class="signup-link">
                Don't have an account? <a href="userSighup.jsp">Create Account</a>
            </div>
        </div>
    </div>
</body>
</html>