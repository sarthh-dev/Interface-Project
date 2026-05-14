<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SRC Fast Food - Best Food in Town</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: #0a0a0a;
            overflow-x: hidden;
        }

        /* Animated Background */
        .hero {
            position: relative;
            min-height: 100vh;
            background: linear-gradient(135deg, #0a0a0a 0%, #1a1a2e 100%);
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(228,0,43,0.1) 0%, transparent 70%);
            animation: pulse 10s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: translate(-25%, -25%) scale(1); opacity: 0.5; }
            50% { transform: translate(-25%, -25%) scale(1.1); opacity: 0.8; }
        }

        /* Floating Food Items */
        .floating-food {
            position: absolute;
            font-size: 60px;
            opacity: 0.1;
            animation: float 20s infinite linear;
        }

        @keyframes float {
            0% { transform: translateY(100vh) rotate(0deg); }
            100% { transform: translateY(-100vh) rotate(360deg); }
        }

        /* Navbar */
        .navbar {
            position: fixed;
            top: 0;
            width: 100%;
            padding: 1.5rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 1000;
            background: rgba(10, 10, 10, 0.95);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-icon {
            width: 50px;
            height: 50px;
            background: #E4002B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            animation: rotate 10s linear infinite;
        }

        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .logo-text h1 {
            color: #E4002B;
            font-size: 28px;
            letter-spacing: 2px;
        }

        .logo-text p {
            color: #FFC72C;
            font-size: 10px;
            letter-spacing: 3px;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: 0.3s;
            position: relative;
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 0;
            height: 2px;
            background: #E4002B;
            transition: 0.3s;
        }

        .nav-links a:hover::after {
            width: 100%;
        }

        /* Hero Content */
        .hero-content {
            position: relative;
            z-index: 2;
            display: flex;
            align-items: center;
            justify-content: space-between;
            min-height: 100vh;
            padding: 0 5%;
            gap: 4rem;
        }

        .hero-text {
            flex: 1;
            animation: slideInLeft 1s ease;
        }

        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-100px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .hero-badge {
            background: rgba(228, 0, 43, 0.2);
            display: inline-block;
            padding: 8px 20px;
            border-radius: 50px;
            color: #E4002B;
            font-weight: 600;
            margin-bottom: 20px;
            backdrop-filter: blur(5px);
        }

        .hero-text h1 {
            font-size: 70px;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 20px;
        }

        .hero-text h1 span {
            color: #E4002B;
            display: inline-block;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .hero-text p {
            color: #aaa;
            font-size: 18px;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .hero-stats {
            display: flex;
            gap: 2rem;
            margin-bottom: 30px;
        }

        .stat {
            text-align: center;
        }

        .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: #E4002B;
        }

        .stat-label {
            font-size: 12px;
            color: #888;
        }

        .btn-group {
            display: flex;
            gap: 1rem;
        }

        .btn-primary {
            padding: 15px 40px;
            background: #E4002B;
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(228, 0, 43, 0.4);
        }

        .btn-outline {
            padding: 15px 40px;
            background: transparent;
            color: white;
            border: 2px solid #E4002B;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-outline:hover {
            background: #E4002B;
            transform: translateY(-3px);
        }

        .hero-image {
            flex: 1;
            position: relative;
            animation: slideInRight 1s ease;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(100px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .hero-image img {
            width: 100%;
            max-width: 500px;
            filter: drop-shadow(0 20px 40px rgba(0,0,0,0.3));
            animation: floatImage 3s ease-in-out infinite;
        }

        @keyframes floatImage {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }

        /* Features Section */
        .features {
            padding: 80px 5%;
            background: #111;
        }

        .section-title {
            text-align: center;
            margin-bottom: 50px;
        }

        .section-title h2 {
            font-size: 40px;
            color: white;
            margin-bottom: 10px;
        }

        .section-title p {
            color: #888;
        }

        .section-title span {
            color: #E4002B;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .feature-card {
            background: #1a1a1a;
            padding: 40px 30px;
            border-radius: 20px;
            text-align: center;
            transition: 0.3s;
            cursor: pointer;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            background: #222;
        }

        .feature-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #E4002B, #FFC72C);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 35px;
        }

        .feature-card h3 {
            color: white;
            margin-bottom: 10px;
        }

        .feature-card p {
            color: #888;
            font-size: 14px;
        }

        /* CTA Section */
        .cta {
            padding: 80px 5%;
            background: linear-gradient(135deg, #E4002B, #c90026);
            text-align: center;
        }

        .cta h2 {
            font-size: 48px;
            color: white;
            margin-bottom: 20px;
        }

        .cta p {
            color: rgba(255,255,255,0.9);
            margin-bottom: 30px;
        }

        .btn-cta {
            padding: 15px 50px;
            background: #FFC72C;
            color: #222;
            border: none;
            border-radius: 50px;
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-cta:hover {
            transform: scale(1.05);
        }

        /* Footer */
        .footer {
            background: #0a0a0a;
            padding: 60px 5% 30px;
            border-top: 1px solid #222;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 3rem;
            margin-bottom: 40px;
        }

        .footer-section h3 {
            color: white;
            margin-bottom: 20px;
        }

        .footer-section p, .footer-section a {
            color: #888;
            text-decoration: none;
            line-height: 2;
            display: block;
        }

        .social-links {
            display: flex;
            gap: 1rem;
            margin-top: 20px;
        }

        .social-links a {
            width: 40px;
            height: 40px;
            background: #1a1a1a;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: 0.3s;
        }

        .social-links a:hover {
            background: #E4002B;
            transform: translateY(-3px);
        }

        .footer-bottom {
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid #222;
            color: #666;
            font-size: 14px;
        }

        @media (max-width: 968px) {
            .hero-content {
                flex-direction: column;
                text-align: center;
                padding-top: 100px;
            }
            .hero-text h1 {
                font-size: 40px;
            }
            .hero-stats {
                justify-content: center;
            }
            .btn-group {
                justify-content: center;
            }
            .nav-links {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="hero">
        <!-- Floating Food Items -->
        <div class="floating-food" style="left: 10%; animation-duration: 25s;">🍔</div>
        <div class="floating-food" style="right: 15%; animation-duration: 20s; animation-delay: 2s;">🍕</div>
        <div class="floating-food" style="left: 20%; bottom: 0; animation-duration: 30s;">🍟</div>
        <div class="floating-food" style="right: 25%; top: 20%; animation-duration: 22s;">🥤</div>

        <nav class="navbar">
            <div class="logo">
                <div class="logo-icon">🍔</div>
                <div class="logo-text">
                    <h1>SRC</h1>
                    <p>FAST FOOD</p>
                </div>
            </div>
            <div class="nav-links">
                <a href="#">Home</a>
                <a href="#">Menu</a>
                <a href="#">Offers</a>
                <a href="#">Contact</a>
            </div>
        </nav>

        <div class="hero-content">
            <div class="hero-text">
                <div class="hero-badge">
                    <i class="fas fa-fire"></i> 50% OFF Today!
                </div>
                <h1>
                    Taste The <span>Real<br>Flavor</span> of Food
                </h1>
                <p>Experience the best fast food in town with our signature recipes.<br>Fresh, hot, and delivered right to your doorstep.</p>
                
                <div class="hero-stats">
                    <div class="stat">
                        <div class="stat-number">50+</div>
                        <div class="stat-label">Food Items</div>
                    </div>
                    <div class="stat">
                        <div class="stat-number">10k+</div>
                        <div class="stat-label">Happy Customers</div>
                    </div>
                    <div class="stat">
                        <div class="stat-number">30min</div>
                        <div class="stat-label">Fast Delivery</div>
                    </div>
                </div>

                <div class="btn-group">
                    <a href="userLogin.jsp" class="btn-primary"><i class="fas fa-user"></i> User Login</a>
                    <a href="adminLogin.jsp" class="btn-outline"><i class="fas fa-shield-alt"></i> Admin</a>
                </div>
            </div>
            <div class="hero-image">
                <img src="images/IMG_1548.JPG" alt="Burger" onerror="this.src='https://via.placeholder.com/500x500?text=🍔'">
            </div>
        </div>
    </div>

    <div class="features">
        <div class="section-title">
            <h2>Why Choose <span>SRC Fast Food</span>?</h2>
            <p>We provide the best quality food with fastest delivery</p>
        </div>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">🍔</div>
                <h3>Premium Quality</h3>
                <p>100% fresh ingredients used in every dish</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🚀</div>
                <h3>Fast Delivery</h3>
                <p>Delivery within 30 minutes guaranteed</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">💰</div>
                <h3>Best Prices</h3>
                <p>Affordable prices with great offers</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🌟</div>
                <h3>24/7 Support</h3>
                <p>Customer support always available</p>
            </div>
        </div>
    </div>

    <div class="cta">
        <h2>Ready to Order?</h2>
        <p>Join thousands of happy customers who love our food</p>
        <button class="btn-cta" onclick="location.href='userLogin.jsp'">Order Now <i class="fas fa-arrow-right"></i></button>
    </div>

    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h3>SRC Fast Food</h3>
                <p>Sarthak & Rohan's Cafe</p>
                <p>Delivering happiness since 2024</p>
                <div class="social-links">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
            <div class="footer-section">
                <h3>Quick Links</h3>
                <a href="#">About Us</a>
                <a href="#">Menu</a>
                <a href="#">Offers</a>
                <a href="#">Contact</a>
            </div>
            <div class="footer-section">
                <h3>Contact Info</h3>
                <p><i class="fas fa-map-marker-alt"></i> pune, India</p>
                <p><i class="fas fa-phone"></i> +91 7499605121</p>
                <p><i class="fas fa-envelope"></i> src@fastfood.com</p>
            </div>
            <div class="footer-section">
                <h3>Opening Hours</h3>
                <p>Monday - Sunday</p>
                <p>10:00 AM - 11:00 PM</p>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2024 SRC Fast Food. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>