<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - SRC Fast Food</title>
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
            padding: 20px;
        }

        .signup-container {
            width: 100%;
            max-width: 500px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 30px;
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            animation: fadeIn 0.6s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #E4002B, #FFC72C);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 35px;
        }

        .logo h2 {
            color: white;
            font-size: 24px;
        }

        .logo p {
            color: #888;
            font-size: 12px;
        }

        .input-group {
            margin-bottom: 20px;
        }

        .input-group label {
            display: block;
            color: #ccc;
            margin-bottom: 8px;
            font-size: 13px;
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
        }

        .input-field input, .input-field select {
            width: 100%;
            padding: 12px 15px 12px 45px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: white;
            font-size: 14px;
        }

        .input-field select option {
            background: #1a1a1a;
        }

        .input-field input:focus, .input-field select:focus {
            outline: none;
            border-color: #E4002B;
        }

        .btn-signup {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #E4002B, #c90026);
            border: none;
            border-radius: 12px;
            color: white;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 10px;
        }

        .btn-signup:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(228, 0, 43, 0.3);
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #888;
        }

        .login-link a {
            color: #E4002B;
            text-decoration: none;
        }

        .error {
            background: rgba(220, 53, 69, 0.2);
            border: 1px solid #dc3545;
            color: #dc3545;
            padding: 10px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 13px;
        }

        .gender-group {
            display: flex;
            gap: 20px;
            padding: 10px 0;
        }

        .gender-option {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #ccc;
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <div class="logo">
            <div class="logo-icon">🍔</div>
            <h2>Create Account</h2>
            <p>Join SRC Fast Food family</p>
        </div>

        <% if(request.getParameter("error") != null) { %>
            <div class="error">
                <i class="fas fa-exclamation-circle"></i> <%= request.getParameter("error") %>
            </div>
        <% } %>

        <form action="UserAuthServlet" method="post">
            <input type="hidden" name="action" value="signup">

            <div class="input-group">
                <label><i class="fas fa-user"></i> Full Name</label>
                <div class="input-field">
                    <i class="fas fa-user"></i>
                    <input type="text" name="name" placeholder="Enter your full name" required>
                </div>
            </div>

            <div class="input-group">
                <label><i class="fas fa-envelope"></i> Email Address</label>
                <div class="input-field">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" placeholder="Enter your email" required>
                </div>
            </div>

            <div class="input-group">
                <label><i class="fas fa-venus-mars"></i> Gender</label>
                <div class="gender-group">
                    <label class="gender-option">
                        <input type="radio" name="gender" value="Male" checked> Male
                    </label>
                    <label class="gender-option">
                        <input type="radio" name="gender" value="Female"> Female
                    </label>
                    <label class="gender-option">
                        <input type="radio" name="gender" value="Other"> Other
                    </label>
                </div>
            </div>

            <div class="input-group">
                <label><i class="fas fa-phone"></i> Contact Number</label>
                <div class="input-field">
                    <i class="fas fa-phone"></i>
                    <input type="tel" name="contact" placeholder="Enter mobile number" required>
                </div>
            </div>

            <div class="input-group">
                <label><i class="fas fa-lock"></i> Password</label>
                <div class="input-field">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" placeholder="Create a password" required>
                </div>
            </div>

            <button type="submit" class="btn-signup">
                <i class="fas fa-user-plus"></i> Sign Up
            </button>
        </form>

        <div class="login-link">
            Already have an account? <a href="userLogin.jsp">Login here</a>
        </div>
    </div>
</body>
</html>