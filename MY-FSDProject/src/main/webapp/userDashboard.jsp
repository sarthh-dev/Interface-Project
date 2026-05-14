<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.src.model.Food, com.src.dao.FoodDAO" %>
<%
    if(session.getAttribute("userEmail") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
    String userEmail = (String) session.getAttribute("userEmail");
    String displayName = (String) session.getAttribute("userName");
    if(displayName == null) displayName = userEmail;
    
    FoodDAO foodDAO = new FoodDAO();
    List<Food> allFoods = foodDAO.getAllFoodItems();
    
    Set<String> categories = new HashSet<>();
    for(Food food : allFoods) {
        if(food.getCategory() != null) {
            categories.add(food.getCategory());
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - SRC Fast Food</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background: #0a0a0a;
            color: white;
        }
        .navbar {
            background: rgba(10, 10, 10, 0.95);
            backdrop-filter: blur(10px);
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            flex-wrap: wrap;
        }
        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .logo-icon {
            width: 45px;
            height: 45px;
            background: #E4002B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        .logo h1 {
            font-size: 24px;
            color: #E4002B;
        }
        .nav-links {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }
        .nav-links button, .nav-links a {
            background: none;
            border: none;
            color: white;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            padding: 8px 16px;
            border-radius: 25px;
            transition: 0.3s;
            text-decoration: none;
        }
        .nav-links button:hover, .nav-links a:hover {
            background: rgba(228, 0, 43, 0.2);
        }
        .cart-btn {
            background: #E4002B !important;
            position: relative;
        }
        .cart-count {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #FFC72C;
            color: #222;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 11px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        .logout-btn {
            background: rgba(228, 0, 43, 0.3) !important;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 5%;
        }
        .welcome-banner {
            background: linear-gradient(135deg, #E4002B, #c90026);
            border-radius: 30px;
            padding: 40px;
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
        }
        .welcome-banner::before {
            content: '🍔🍕🍟';
            position: absolute;
            right: -50px;
            bottom: -50px;
            font-size: 150px;
            opacity: 0.1;
        }
        .welcome-banner h2 {
            font-size: 32px;
            margin-bottom: 10px;
        }
        .category-filter {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-bottom: 40px;
            background: #111;
            padding: 15px;
            border-radius: 50px;
        }
        .category-btn {
            padding: 10px 25px;
            background: transparent;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 50px;
            color: white;
            cursor: pointer;
            transition: 0.3s;
            font-weight: 500;
        }
        .category-btn.active, .category-btn:hover {
            background: #E4002B;
            border-color: #E4002B;
        }
        .food-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 30px;
        }
        .food-card {
            background: #111;
            border-radius: 20px;
            overflow: hidden;
            transition: 0.3s;
            position: relative;
        }
        .food-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }
        .food-image {
            height: 200px;
            background: linear-gradient(135deg, #1a1a1a, #222);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 80px;
            position: relative;
        }
        .veg-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
        }
        .veg { background: #28a745; }
        .non-veg { background: #dc3545; }
        .wishlist-btn {
            position: absolute;
            top: 15px;
            left: 15px;
            background: rgba(0,0,0,0.5);
            border: none;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            color: white;
            cursor: pointer;
            transition: 0.3s;
        }
        .food-info {
            padding: 20px;
        }
        .food-name {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .food-category {
            color: #888;
            font-size: 13px;
            margin-bottom: 10px;
        }
        .food-price {
            font-size: 24px;
            font-weight: 700;
            color: #E4002B;
            margin: 15px 0;
        }
        .add-to-cart {
            width: 100%;
            padding: 12px;
            background: #E4002B;
            border: none;
            border-radius: 12px;
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }
        .customize-btn {
            width: 100%;
            padding: 10px;
            background: transparent;
            border: 1px solid #FFC72C;
            border-radius: 12px;
            color: #FFC72C;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            transition: 0.3s;
        }
        .customize-btn:hover {
            background: #FFC72C;
            color: #222;
        }
        .review-btn {
            width: 48%;
            padding: 10px;
            background: transparent;
            border: 1px solid #E4002B;
            border-radius: 12px;
            color: #E4002B;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            transition: 0.3s;
            display: inline-block;
        }
        .review-btn:hover {
            background: #E4002B;
            color: white;
        }
        .view-reviews-btn {
            width: 48%;
            padding: 10px;
            background: transparent;
            border: 1px solid #17a2b8;
            border-radius: 12px;
            color: #17a2b8;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            transition: 0.3s;
            float: right;
        }
        .view-reviews-btn:hover {
            background: #17a2b8;
            color: white;
        }
        .history-section {
            background: #111;
            border-radius: 20px;
            padding: 30px;
            margin-top: 40px;
        }
        .history-section h3 {
            margin-bottom: 20px;
            font-size: 24px;
        }
        .order-table {
            width: 100%;
            border-collapse: collapse;
            overflow-x: auto;
            display: block;
        }
        .order-table th, .order-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #222;
        }
        .order-table th {
            color: #E4002B;
            font-weight: 600;
        }
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        .status-delivered { background: #28a745; }
        .status-processing { background: #FFC72C; color: #222; }
        .status-preparing { background: #17a2b8; }
        .status-outfordelivery { background: #fd7e14; }
        .status-cancelled { background: #dc3545; }
        .action-btns {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .track-btn, .reorder-btn, .cancel-btn {
            border: none;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            cursor: pointer;
            transition: 0.3s;
        }
        .track-btn { background: #E4002B; color: white; }
        .reorder-btn { background: #FFC72C; color: #222; }
        .cancel-btn { background: #dc3545; color: white; }
        .about-section {
            background: #111;
            border-radius: 20px;
            padding: 30px;
        }
        .about-section h3 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #E4002B;
        }
        .about-section p {
            line-height: 1.8;
            color: #ccc;
        }
        .about-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        .about-card {
            background: #1a1a1a;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
        }
        .about-card i {
            font-size: 40px;
            color: #E4002B;
            margin-bottom: 15px;
        }
        .about-card h4 {
            margin-bottom: 10px;
        }
        .message {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: #28a745;
            color: white;
            padding: 15px 25px;
            border-radius: 50px;
            z-index: 1000;
            display: none;
            animation: slideIn 0.3s ease;
        }
        @keyframes slideIn {
            from { transform: translateX(100px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.95);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: #111;
            border-radius: 20px;
            padding: 30px;
            max-width: 500px;
            width: 90%;
            max-height: 85vh;
            overflow-y: auto;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .modal-header h3 {
            color: #E4002B;
        }
        .close-modal {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
        }
        .customization-option {
            margin-bottom: 20px;
            padding: 15px;
            background: #1a1a1a;
            border-radius: 15px;
        }
        .customization-title {
            font-weight: bold;
            margin-bottom: 10px;
            color: #FFC72C;
        }
        .topping-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            margin: 5px 0;
            background: #222;
            border-radius: 10px;
        }
        .topping-name {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .topping-price {
            color: #E4002B;
            font-size: 12px;
        }
        .topping-checkbox {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }
        .spice-level {
            display: flex;
            gap: 15px;
            margin-top: 10px;
            flex-wrap: wrap;
        }
        .spice-btn {
            padding: 8px 20px;
            background: #222;
            border: 1px solid #333;
            border-radius: 25px;
            cursor: pointer;
            transition: 0.3s;
        }
        .spice-btn.active {
            background: #E4002B;
            border-color: #E4002B;
        }
        .instruction-input {
            width: 100%;
            padding: 12px;
            background: #222;
            border: 1px solid #333;
            border-radius: 10px;
            color: white;
            margin-top: 10px;
        }
        .price-breakdown {
            background: #1a1a1a;
            border-radius: 15px;
            padding: 15px;
            margin: 15px 0;
        }
        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #333;
        }
        .price-row.total {
            font-size: 18px;
            font-weight: bold;
            color: #E4002B;
            border-bottom: none;
            padding-top: 15px;
        }
        .add-to-cart-custom {
            width: 100%;
            padding: 15px;
            background: #28a745;
            border: none;
            border-radius: 12px;
            color: white;
            font-weight: bold;
            font-size: 16px;
            cursor: pointer;
            margin-top: 15px;
        }
        .rating-stars {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin: 20px 0;
        }
        .rating-stars i {
            font-size: 35px;
            cursor: pointer;
            color: #555;
            transition: 0.2s;
        }
        .rating-stars i.selected {
            color: #FFC72C;
        }
        .review-textarea {
            width: 100%;
            padding: 15px;
            background: #222;
            border: 1px solid #333;
            border-radius: 15px;
            color: white;
            resize: vertical;
            margin: 15px 0;
        }
        .submit-review {
            width: 100%;
            padding: 12px;
            background: #E4002B;
            border: none;
            border-radius: 12px;
            color: white;
            font-weight: 600;
            cursor: pointer;
        }
        .reviews-list {
            max-height: 400px;
            overflow-y: auto;
        }
        .review-item {
            background: #1a1a1a;
            border-radius: 15px;
            padding: 15px;
            margin-bottom: 15px;
        }
        .review-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .review-user {
            font-weight: bold;
            color: #E4002B;
        }
        .review-rating i {
            color: #FFC72C;
            font-size: 12px;
        }
        .review-text {
            color: #ccc;
            font-size: 14px;
            line-height: 1.5;
            margin: 10px 0;
        }
        .review-date {
            color: #666;
            font-size: 11px;
        }
        .no-reviews {
            text-align: center;
            padding: 40px;
            color: #888;
        }
        .tracking-timeline {
            margin: 20px 0;
        }
        .timeline-step {
            display: flex;
            align-items: flex-start;
            margin-bottom: 25px;
            position: relative;
        }
        .timeline-icon {
            width: 40px;
            height: 40px;
            background: #222;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            z-index: 2;
            font-size: 18px;
        }
        .timeline-icon.active {
            background: #E4002B;
            animation: pulse 1s infinite;
        }
        .timeline-icon.completed {
            background: #28a745;
        }
        .timeline-content {
            flex: 1;
        }
        .timeline-title {
            font-weight: bold;
            margin-bottom: 5px;
        }
        .timeline-title.active { color: #E4002B; }
        .timeline-title.completed { color: #28a745; }
        .timeline-time { font-size: 12px; color: #888; }
        .timeline-step:not(:last-child)::after {
            content: '';
            position: absolute;
            left: 20px;
            top: 40px;
            width: 2px;
            height: 35px;
            background: #333;
        }
        .delivery-info {
            background: #1a1a1a;
            border-radius: 15px;
            padding: 15px;
            margin-top: 20px;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #222;
        }
        .info-row:last-child { border-bottom: none; }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        .wishlist-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            background: #1a1a1a;
            border-radius: 10px;
            margin-bottom: 10px;
        }
        .wishlist-actions {
            display: flex;
            gap: 10px;
        }
        .wishlist-add-cart, .wishlist-remove {
            border: none;
            padding: 8px 15px;
            border-radius: 10px;
            cursor: pointer;
        }
        .wishlist-add-cart { background: #28a745; color: white; }
        .wishlist-remove { background: #dc3545; color: white; }
        .no-orders {
            text-align: center;
            padding: 60px;
        }
        .no-orders i {
            font-size: 80px;
            color: #888;
            margin-bottom: 20px;
        }
        @media (max-width: 768px) {
            .navbar { flex-direction: column; gap: 1rem; }
            .order-table { font-size: 12px; }
            .order-table th, .order-table td { padding: 8px; }
            .review-btn, .view-reviews-btn { width: 100%; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="logo">
        <div class="logo-icon">🍔</div>
        <h1>SRC FAST FOOD</h1>
    </div>
    <div class="nav-links">
        <button onclick="showSection('home')"><i class="fas fa-home"></i> Home</button>
        <button onclick="showSection('history')"><i class="fas fa-history"></i> My Orders</button>
        <button onclick="showSection('about')"><i class="fas fa-info-circle"></i> About</button>
        <button onclick="showWishlist()"><i class="fas fa-heart"></i> Wishlist</button>
        <a href="cart.jsp" class="cart-btn"><i class="fas fa-shopping-cart"></i> Cart <span id="cartCount" class="cart-count">0</span></a>
        <button onclick="logout()" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</button>
    </div>
</nav>

<div class="container">
    <!-- Home Section -->
    <div id="homeSection">
        <div class="welcome-banner">
            <h2>Welcome back, <%= displayName %>! 👋</h2>
            <p>Customize your food with extra toppings and spice levels!</p>
        </div>
        <div class="category-filter">
            <button class="category-btn active" onclick="filterFood('all', this)">All</button>
            <% for(String category : categories) { %>
                <button class="category-btn" onclick="filterFood('<%= category %>', this)"><%= category %></button>
            <% } %>
        </div>
        <div class="food-grid" id="foodGrid">
            <% for(Food food : allFoods) { 
                String vegClass = "";
                if(food.getVegNonveg() != null) {
                    vegClass = food.getVegNonveg().toLowerCase().replace("-", "");
                }
            %>
                <div class="food-card" data-category="<%= food.getCategory() != null ? food.getCategory() : "" %>" data-food-id="<%= food.getFoodId() %>" data-food-name="<%= food.getName() %>" data-food-price="<%= food.getPrice() %>">
                    <div class="food-image">
                        <span>🍔</span>
                        <span class="veg-badge <%= vegClass %>">
                            <%= food.getVegNonveg() != null ? food.getVegNonveg() : "Veg" %>
                        </span>
                        <button class="wishlist-btn" onclick="toggleWishlist(<%= food.getFoodId() %>, this)">
                            <i class="far fa-heart"></i>
                        </button>
                    </div>
                    <div class="food-info">
                        <div class="food-name"><%= food.getName() %></div>
                        <div class="food-category"><%= food.getCategory() != null ? food.getCategory() : "Food" %></div>
                        <div class="food-price">₹ <%= String.format("%.2f", food.getPrice()) %></div>
                        <button class="customize-btn" onclick="openCustomizeModal(<%= food.getFoodId() %>, '<%= food.getName() %>', <%= food.getPrice() %>)">
                            <i class="fas fa-sliders-h"></i> Customize & Add
                        </button>
                        <button class="review-btn" onclick="openReviewModal(<%= food.getFoodId() %>, '<%= food.getName() %>')">
                            <i class="fas fa-star"></i> Write a Review
                        </button>
                        <button class="view-reviews-btn" onclick="openReviewsModal(<%= food.getFoodId() %>, '<%= food.getName() %>')">
                            <i class="fas fa-comments"></i> View Reviews
                        </button>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <!-- My Orders Section -->
    <div id="historySection" style="display:none;">
        <div class="history-section">
            <h3><i class="fas fa-shopping-bag"></i> My Orders</h3>
            <p style="color:#888; margin-bottom: 20px;">Real-time order status updates. Auto-refreshes every 10 seconds.</p>
            <div style="overflow-x: auto;">
                <table class="order-table">
                    <thead>
                        <tr><th>Order ID</th><th>Items</th><th>Amount</th><th>Status</th><th>Order Date</th><th>Actions</th></tr>
                    </thead>
                    <tbody id="orderHistoryBody">
                        <tr><td colspan="6" style="text-align:center; padding: 40px;">
                            <div class="no-orders">
                                <i class="fas fa-shopping-bag"></i>
                                <p>No orders found!</p>
                            </div>
                        </a></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- About Section -->
    <div id="aboutSection" style="display:none;">
        <div class="about-section">
            <h3><i class="fas fa-info-circle"></i> About SRC Fast Food</h3>
            <p>SRC Fast Food is proudly run by <strong>Sarthak & Rohan</strong>. We serve authentic fast food with quality ingredients. Customize your food exactly how you like it!</p>
            
            <div class="about-info">
                <div class="about-card">
                    <i class="fas fa-map-marker-alt"></i>
                    <h4>Our Location</h4>
                    <p>Pune, India</p>
                </div>
                <div class="about-card">
                    <i class="fas fa-phone"></i>
                    <h4>Contact Us</h4>
                    <p>+91 7499605121</p>
                </div>
                <div class="about-card">
                    <i class="fas fa-clock"></i>
                    <h4>Opening Hours</h4>
                    <p>10:00 AM - 11:00 PM</p>
                </div>
                <div class="about-card">
                    <i class="fas fa-envelope"></i>
                    <h4>Email</h4>
                    <p>src@fastfood.com</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Customization Modal -->
<div id="customizeModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-sliders-h"></i> Customize: <span id="customizeFoodName"></span></h3>
            <button class="close-modal" onclick="closeCustomizeModal()">&times;</button>
        </div>
        <div id="customizeContent">
            <div style="text-align:center; padding:20px;">Loading customization options...</div>
        </div>
    </div>
</div>

<!-- Review Modal -->
<div id="reviewModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-star"></i> Rate & Review <span id="reviewFoodName"></span></h3>
            <button class="close-modal" onclick="closeReviewModal()">&times;</button>
        </div>
        <div class="rating-stars" id="ratingStars">
            <i class="far fa-star" data-rating="1"></i>
            <i class="far fa-star" data-rating="2"></i>
            <i class="far fa-star" data-rating="3"></i>
            <i class="far fa-star" data-rating="4"></i>
            <i class="far fa-star" data-rating="5"></i>
        </div>
        <textarea id="reviewText" class="review-textarea" rows="4" placeholder="Share your experience with this food item..."></textarea>
        <button class="submit-review" onclick="submitReview()">Submit Review</button>
    </div>
</div>

<!-- Reviews List Modal -->
<div id="reviewsModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-comments"></i> Reviews for <span id="reviewsFoodName"></span></h3>
            <button class="close-modal" onclick="closeReviewsModal()">&times;</button>
        </div>
        <div id="reviewsList" class="reviews-list"></div>
    </div>
</div>

<!-- Tracking Modal -->
<div id="trackModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-truck"></i> Track Your Order</h3>
            <button class="close-modal" onclick="closeTrackModal()">&times;</button>
        </div>
        <div id="trackContent"></div>
    </div>
</div>

<!-- Wishlist Modal -->
<div id="wishlistModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-heart"></i> My Wishlist</h3>
            <button class="close-modal" onclick="closeWishlistModal()">&times;</button>
        </div>
        <div id="wishlistContent"></div>
    </div>
</div>

<div id="messageBox" class="message"></div>

<script>
    let currentFoodId = null;
    let currentFoodPrice = 0;
    let currentFoodName = "";
    let selectedToppings = [];
    let selectedSpice = "Medium";
    let specialInstructions = "";
    let toppingsList = [];
    let selectedRating = 0;
    let trackInterval;
    let orderRefreshInterval;

    function showMessage(msg, isError) {
        let msgBox = document.getElementById('messageBox');
        msgBox.innerHTML = (isError ? '❌ ' : '✅ ') + msg;
        msgBox.style.background = isError ? '#dc3545' : '#28a745';
        msgBox.style.display = 'block';
        setTimeout(function() { msgBox.style.display = 'none'; }, 3000);
    }

    function showSection(section) {
        document.getElementById('homeSection').style.display = 'none';
        document.getElementById('historySection').style.display = 'none';
        document.getElementById('aboutSection').style.display = 'none';
        
        if(section === 'home') {
            document.getElementById('homeSection').style.display = 'block';
            loadWishlistStatus();
            if(orderRefreshInterval) clearInterval(orderRefreshInterval);
        } else if(section === 'history') {
            document.getElementById('historySection').style.display = 'block';
            loadOrderHistory();
            if(orderRefreshInterval) clearInterval(orderRefreshInterval);
            orderRefreshInterval = setInterval(function() { loadOrderHistory(); }, 10000);
        } else if(section === 'about') {
            document.getElementById('aboutSection').style.display = 'block';
            if(orderRefreshInterval) clearInterval(orderRefreshInterval);
        }
    }

    function addToCart(id, name, price) {
        let cart = JSON.parse(localStorage.getItem('cart') || '[]');
        let existingItem = cart.find(function(item) { return item.id === id; });
        if(existingItem) {
            existingItem.quantity++;
        } else {
            cart.push({ id: id, name: name, price: price, quantity: 1 });
        }
        localStorage.setItem('cart', JSON.stringify(cart));
        updateCartCount();
        showMessage(name + ' added to cart! 🎉', false);
    }

    function updateCartCount() {
        let cart = JSON.parse(localStorage.getItem('cart') || '[]');
        let count = cart.reduce(function(total, item) { return total + item.quantity; }, 0);
        document.getElementById('cartCount').innerText = count;
    }

    function filterFood(category, btn) {
        let cards = document.getElementsByClassName('food-card');
        let buttons = document.getElementsByClassName('category-btn');
        for(let i = 0; i < buttons.length; i++) buttons[i].classList.remove('active');
        btn.classList.add('active');
        for(let i = 0; i < cards.length; i++) {
            let cardCategory = cards[i].getAttribute('data-category');
            cards[i].style.display = (category === 'all' || cardCategory === category) ? 'block' : 'none';
        }
    }

    // ============ CUSTOMIZATION SYSTEM ============
    
    function openCustomizeModal(foodId, foodName, basePrice) {
        currentFoodId = foodId;
        currentFoodName = foodName;
        currentFoodPrice = basePrice;
        selectedToppings = [];
        selectedSpice = "Medium";
        specialInstructions = "";
        
        document.getElementById('customizeFoodName').innerText = foodName;
        document.getElementById('customizeModal').style.display = 'flex';
        
        fetch('ToppingServlet?action=getToppings')
            .then(function(response) { return response.json(); })
            .then(function(data) {
                toppingsList = data;
                renderCustomizeModal();
            })
            .catch(function() {
                toppingsList = [];
                renderCustomizeModal();
            });
    }
    
    function renderCustomizeModal() {
        let html = '';
        
        html += '<div class="customization-option">' +
            '<div class="customization-title"><i class="fas fa-cheese"></i> Add Toppings</div>';
        
        if(toppingsList.length === 0) {
            html += '<div style="color:#888; padding:10px;">No toppings available</div>';
        } else {
            for(let i = 0; i < toppingsList.length; i++) {
                let t = toppingsList[i];
                let isChecked = selectedToppings.includes(t.id);
                html += '<div class="topping-item">' +
                    '<div class="topping-name">' +
                    '<input type="checkbox" class="topping-checkbox" value="' + t.id + '" data-name="' + t.name + '" data-price="' + t.price + '" ' + (isChecked ? 'checked' : '') + ' onchange="toggleTopping(this)">' +
                    '<span>' + t.name + '</span>' +
                    '</div>' +
                    '<div class="topping-price">+₹' + t.price + '</div>' +
                    '</div>';
            }
        }
        html += '</div>';
        
        html += '<div class="customization-option">' +
            '<div class="customization-title"><i class="fas fa-pepper-hot"></i> Spice Level</div>' +
            '<div class="spice-level">' +
            '<div class="spice-btn ' + (selectedSpice === 'Mild' ? 'active' : '') + '" onclick="selectSpice(\'Mild\')">🌿 Mild</div>' +
            '<div class="spice-btn ' + (selectedSpice === 'Medium' ? 'active' : '') + '" onclick="selectSpice(\'Medium\')">🔥 Medium</div>' +
            '<div class="spice-btn ' + (selectedSpice === 'Hot' ? 'active' : '') + '" onclick="selectSpice(\'Hot\')">🌶️ Hot</div>' +
            '<div class="spice-btn ' + (selectedSpice === 'Extra Hot' ? 'active' : '') + '" onclick="selectSpice(\'Extra Hot\')">🔥🌶️ Extra Hot</div>' +
            '</div></div>';
        
        html += '<div class="customization-option">' +
            '<div class="customization-title"><i class="fas fa-pen"></i> Special Instructions</div>' +
            '<textarea id="specialInstructions" class="instruction-input" rows="2" placeholder="Any special requests? (e.g., extra cheese, no onion, etc.)"></textarea>' +
            '</div>';
        
        let toppingsTotal = 0;
        for(let i = 0; i < selectedToppings.length; i++) {
            let topping = toppingsList.find(function(t) { return t.id == selectedToppings[i]; });
            if(topping) toppingsTotal += topping.price;
        }
        let totalPrice = currentFoodPrice + toppingsTotal;
        
        html += '<div class="price-breakdown">' +
            '<div class="price-row"><span>Base Price:</span><span>₹' + currentFoodPrice.toFixed(2) + '</span></div>' +
            '<div class="price-row"><span>Toppings (+' + selectedToppings.length + '):</span><span>+₹' + toppingsTotal.toFixed(2) + '</span></div>' +
            '<div class="price-row total"><span>Total Amount:</span><span>₹' + totalPrice.toFixed(2) + '</span></div>' +
            '</div>';
        
        html += '<button class="add-to-cart-custom" onclick="addCustomizedToCart()">' +
            '<i class="fas fa-cart-plus"></i> Add to Cart - ₹' + totalPrice.toFixed(2) + '</button>';
        
        document.getElementById('customizeContent').innerHTML = html;
    }
    
    function toggleTopping(checkbox) {
        let toppingId = parseInt(checkbox.value);
        if(checkbox.checked) {
            if(!selectedToppings.includes(toppingId)) selectedToppings.push(toppingId);
        } else {
            let index = selectedToppings.indexOf(toppingId);
            if(index > -1) selectedToppings.splice(index, 1);
        }
        renderCustomizeModal();
    }
    
    function selectSpice(level) {
        selectedSpice = level;
        renderCustomizeModal();
    }
    
    function addCustomizedToCart() {
        let specialInst = document.getElementById('specialInstructions') ? document.getElementById('specialInstructions').value : '';
        
        let toppingsTotal = 0;
        let selectedToppingsNames = [];
        for(let i = 0; i < selectedToppings.length; i++) {
            let topping = toppingsList.find(function(t) { return t.id == selectedToppings[i]; });
            if(topping) {
                toppingsTotal += topping.price;
                selectedToppingsNames.push(topping.name);
            }
        }
        
        let totalPrice = currentFoodPrice + toppingsTotal;
        let customizationText = '';
        if(selectedToppingsNames.length > 0) customizationText += ' + ' + selectedToppingsNames.join(', ');
        customizationText += ' | Spice: ' + selectedSpice;
        if(specialInst) customizationText += ' | Note: ' + specialInst;
        
        let customizedName = currentFoodName + customizationText;
        let cart = JSON.parse(localStorage.getItem('cart') || '[]');
        let existingItem = cart.find(function(item) { return item.id === currentFoodId && item.customization === customizationText; });
        
        if(existingItem) {
            existingItem.quantity++;
        } else {
            cart.push({ id: currentFoodId, name: customizedName, originalName: currentFoodName, price: totalPrice, quantity: 1, customization: customizationText });
        }
        
        localStorage.setItem('cart', JSON.stringify(cart));
        updateCartCount();
        showMessage(currentFoodName + ' added to cart with customization! 🎉', false);
        closeCustomizeModal();
    }
    
    function closeCustomizeModal() {
        document.getElementById('customizeModal').style.display = 'none';
    }

    // ============ REVIEW SYSTEM ============
    
    function openReviewModal(foodId, foodName) {
        currentFoodId = foodId;
        document.getElementById('reviewFoodName').innerText = foodName;
        document.getElementById('reviewText').value = '';
        selectedRating = 0;
        let stars = document.querySelectorAll('#ratingStars i');
        stars.forEach(function(star) {
            star.classList.remove('fas', 'selected');
            star.classList.add('far');
        });
        document.getElementById('reviewModal').style.display = 'flex';
    }
    
    function closeReviewModal() {
        document.getElementById('reviewModal').style.display = 'none';
    }
    
    document.querySelectorAll('#ratingStars i').forEach(function(star) {
        star.addEventListener('click', function() {
            selectedRating = parseInt(this.getAttribute('data-rating'));
            let allStars = document.querySelectorAll('#ratingStars i');
            allStars.forEach(function(s, index) {
                if(index < selectedRating) {
                    s.classList.remove('far');
                    s.classList.add('fas', 'selected');
                } else {
                    s.classList.remove('fas', 'selected');
                    s.classList.add('far');
                }
            });
        });
    });
    
    function submitReview() {
        if(selectedRating === 0) {
            showMessage('Please select a rating!', true);
            return;
        }
        let reviewText = document.getElementById('reviewText').value.trim();
        if(reviewText === '') {
            showMessage('Please write a review!', true);
            return;
        }
        if(reviewText.length < 5) {
            showMessage('Review must be at least 5 characters!', true);
            return;
        }
        
        fetch('ReviewServlet?foodId=' + currentFoodId + '&rating=' + selectedRating + '&reviewText=' + encodeURIComponent(reviewText), { method: 'POST' })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                showMessage(data.message, !data.success);
                if(data.success) closeReviewModal();
            })
            .catch(function() { showMessage('Error submitting review', true); });
    }
    
    function openReviewsModal(foodId, foodName) {
        document.getElementById('reviewsFoodName').innerText = foodName;
        document.getElementById('reviewsModal').style.display = 'flex';
        
        fetch('ReviewServlet?foodId=' + foodId)
            .then(function(response) { return response.json(); })
            .then(function(reviews) {
                let html = '';
                if(reviews.length === 0) {
                    html = '<div class="no-reviews"><i class="far fa-comment-dots" style="font-size:50px; margin-bottom:15px;"></i><p>No reviews yet. Be the first to review!</p></div>';
                } else {
                    reviews.forEach(function(review) {
                        let stars = '';
                        for(let i = 1; i <= 5; i++) {
                            stars += '<i class="fas fa-star" style="color:' + (i <= review.rating ? '#FFC72C' : '#555') + '; font-size:12px;"></i>';
                        }
                        let dateText = review.reviewDate ? review.reviewDate.substring(0,16) : 'Recently';
                        html += '<div class="review-item">' +
                            '<div class="review-header">' +
                            '<span class="review-user"><i class="fas fa-user"></i> ' + review.userName + '</span>' +
                            '<span class="review-rating">' + stars + '</span>' +
                            '</div>' +
                            '<div class="review-text">' + review.reviewText + '</div>' +
                            '<div class="review-date"><i class="far fa-calendar-alt"></i> ' + dateText + '</div>' +
                            '</div>';
                    });
                }
                document.getElementById('reviewsList').innerHTML = html;
            })
            .catch(function() {
                document.getElementById('reviewsList').innerHTML = '<div class="no-reviews"><p>Error loading reviews</p></div>';
            });
    }
    
    function closeReviewsModal() {
        document.getElementById('reviewsModal').style.display = 'none';
    }

    // ============ ORDER HISTORY ============
    
    function formatOrderDate(dateStr) {
        if(!dateStr) return 'N/A';
        try {
            let date = new Date(dateStr);
            return date.toLocaleString('en-IN', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
        } catch(e) {
            return dateStr.substring(0,16);
        }
    }

    function getCalculatedStatus(orderDateStr, dbStatus) {
        if(dbStatus === 'Cancelled') return 'Cancelled';
        if(dbStatus === 'Delivered') return 'Delivered';
        try {
            let orderDate = new Date(orderDateStr);
            let now = new Date();
            let diffMinutes = Math.floor((now - orderDate) / (1000 * 60));
            if (diffMinutes >= 60) return 'Delivered';
            else if (diffMinutes >= 40) return 'Out for Delivery';
            else if (diffMinutes >= 20) return 'Preparing';
            else return 'Processing';
        } catch(e) {
            return dbStatus || 'Processing';
        }
    }

    function loadOrderHistory() {
        fetch('TransactionServlet?action=getUserTransactions')
            .then(function(response) { return response.json(); })
            .then(function(transactions) {
                let html = '';
                if(transactions.length === 0) {
                    html = '<tr><td colspan="6" style="text-align:center; padding: 40px;"><div class="no-orders"><i class="fas fa-shopping-bag"></i><p>No orders found!</p></div></td></tr>';
                } else {
                    for(let i = 0; i < transactions.length; i++) {
                        let t = transactions[i];
                        let calculatedStatus = getCalculatedStatus(t.transactionDate, t.orderStatus);
                        let statusClass = 'status-processing';
                        if(calculatedStatus === 'Delivered') statusClass = 'status-delivered';
                        else if(calculatedStatus === 'Preparing') statusClass = 'status-preparing';
                        else if(calculatedStatus === 'Out for Delivery') statusClass = 'status-outfordelivery';
                        let dateDisplay = formatOrderDate(t.transactionDate);
                        let itemsDisplay = t.items ? (t.items.length > 40 ? t.items.substring(0,40) + '...' : t.items) : '-';
                        let canCancel = (calculatedStatus !== 'Delivered' && calculatedStatus !== 'Cancelled');
                        html += '<tr>' +
                            '<td>#' + t.transactionId + '</td>' +
                            '<td>' + itemsDisplay + '</td>' +
                            '<td>₹' + parseFloat(t.amount).toFixed(2) + '</td>' +
                            '<td><span class="status-badge ' + statusClass + '">' + calculatedStatus + '</span></td>' +
                            '<td>' + dateDisplay + '</td>' +
                            '<td><div class="action-btns">' +
                            '<button class="track-btn" onclick="trackOrder(' + t.transactionId + ')"><i class="fas fa-map-marker-alt"></i> Track</button>' +
                            '<button class="reorder-btn" onclick="reorderItems(\'' + (t.items || '').replace(/'/g, "\\'") + '\')"><i class="fas fa-redo"></i> Reorder</button>';
                        if(canCancel) html += '<button class="cancel-btn" onclick="cancelOrder(' + t.transactionId + ')"><i class="fas fa-times"></i> Cancel</button>';
                        html += '</div></td></tr>';
                    }
                }
                document.getElementById('orderHistoryBody').innerHTML = html;
            })
            .catch(function(error) {
                console.error('Error:', error);
                document.getElementById('orderHistoryBody').innerHTML = '<tr><td colspan="6" style="text-align:center; color:#dc3545;">Error loading orders</a></tr>';
            });
    }

    function reorderItems(items) {
        if(!items) { showMessage('No items to reorder', true); return; }
        let cart = JSON.parse(localStorage.getItem('cart') || '[]');
        let itemArray = items.split(',');
        for(let i = 0; i < itemArray.length; i++) {
            let match = itemArray[i].trim().match(/(.+?)\s*x(\d+)$/);
            if(match) {
                let existing = cart.find(function(item) { return item.name === match[1].trim(); });
                if(existing) existing.quantity += parseInt(match[2]);
                else cart.push({ id: Date.now() + i, name: match[1].trim(), price: 100, quantity: parseInt(match[2]) });
            }
        }
        localStorage.setItem('cart', JSON.stringify(cart));
        updateCartCount();
        showMessage('Items added to cart for reorder!', false);
        showSection('home');
    }

    function cancelOrder(orderId) {
        if(confirm('Are you sure you want to cancel this order?')) {
            fetch('OrderActionServlet?action=cancel&transactionId=' + orderId, { method: 'POST' })
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    showMessage(data.message, !data.success);
                    if(data.success) loadOrderHistory();
                })
                .catch(function() { showMessage('Error cancelling order', true); });
        }
    }

    // ============ TRACKING SYSTEM ============
    
    function trackOrder(orderId) {
        document.getElementById('trackModal').style.display = 'flex';
        fetchOrderStatus(orderId);
        if(trackInterval) clearInterval(trackInterval);
        trackInterval = setInterval(function() { fetchOrderStatus(orderId); }, 5000);
    }
    
    function fetchOrderStatus(orderId) {
        fetch('OrderTrackingServlet?transactionId=' + orderId)
            .then(function(response) { return response.json(); })
            .then(function(data) {
                let html = '';
                if(data.error) {
                    html = '<div style="color:#dc3545; text-align:center; padding:20px;">' + data.error + '</div>';
                } else {
                    let steps = [
                        { name: 'Order Placed', status: 'Processing', icon: '📝', desc: 'Your order has been received' },
                        { name: 'Preparing', status: 'Preparing', icon: '🍳', desc: 'Restaurant is preparing your food' },
                        { name: 'Out for Delivery', status: 'Out for Delivery', icon: '🚚', desc: 'Your order is on the way' },
                        { name: 'Delivered', status: 'Delivered', icon: '✅', desc: 'Order delivered successfully' }
                    ];
                    let currentStatus = data.orderStatus;
                    let currentStepIndex = -1;
                    for(let i = 0; i < steps.length; i++) {
                        if(steps[i].status === currentStatus) { currentStepIndex = i; break; }
                    }
                    if(currentStepIndex === -1) currentStepIndex = 0;
                    
                    let timelineHtml = '<div class="tracking-timeline">';
                    for(let i = 0; i < steps.length; i++) {
                        let isCompleted = i <= currentStepIndex;
                        let isActive = i === currentStepIndex;
                        timelineHtml += '<div class="timeline-step">' +
                            '<div class="timeline-icon ' + (isCompleted ? 'completed' : '') + (isActive ? ' active' : '') + '">' + steps[i].icon + '</div>' +
                            '<div class="timeline-content">' +
                            '<div class="timeline-title ' + (isCompleted ? 'completed' : '') + (isActive ? ' active' : '') + '">' + steps[i].name + '</div>' +
                            '<div class="timeline-time">' + steps[i].desc + '</div>';
                        if(isActive && data.estimatedDelivery && currentStatus !== 'Delivered') {
                            timelineHtml += '<div class="timeline-time" style="color:#E4002B; margin-top:5px;">⏱️ ' + data.estimatedDelivery + '</div>';
                        }
                        timelineHtml += '</div></div>';
                    }
                    timelineHtml += '</div>';
                    
                    let deliveryHtml = '<div class="delivery-info">' +
                        '<div class="info-row"><span>📦 Order ID:</span><span><strong>#' + orderId + '</strong></span></div>' +
                        '<div class="info-row"><span>🚚 Delivery Partner:</span><span><strong>' + (data.deliveryPartner || 'SRC Delivery') + '</strong></span></div>' +
                        '<div class="info-row"><span>💰 Total Amount:</span><span><strong>₹' + parseFloat(data.orderAmount || 0).toFixed(2) + '</strong></span></div>' +
                        '<div class="info-row"><span>📅 Order Date:</span><span><strong>' + (data.orderDate || 'N/A') + '</strong></span></div>' +
                        '<div class="info-row"><span>🔢 Tracking Number:</span><span><strong>' + (data.trackingNumber || 'N/A') + '</strong></span></div>' +
                        '</div>';
                    if(currentStatus === 'Delivered') {
                        deliveryHtml += '<div style="margin-top:15px; padding:15px; background:rgba(40,167,69,0.2); border-radius:10px; text-align:center;"><i class="fas fa-check-circle" style="color:#28a745; font-size:24px;"></i><p style="color:#28a745; margin-top:5px; font-weight:bold;">Order Delivered Successfully! 🎉</p></div>';
                    }
                    html = timelineHtml + deliveryHtml;
                }
                document.getElementById('trackContent').innerHTML = html;
            })
            .catch(function() {
                document.getElementById('trackContent').innerHTML = '<div style="color:#dc3545; text-align:center; padding:20px;">Error loading tracking info</div>';
            });
    }
    
    function closeTrackModal() {
        document.getElementById('trackModal').style.display = 'none';
        if(trackInterval) clearInterval(trackInterval);
    }

    // ============ WISHLIST SYSTEM ============
    
    function loadWishlistStatus() {
        fetch('WishlistServlet')
            .then(function(response) { return response.json(); })
            .then(function(items) {
                let wishlistIds = [];
                for(let i = 0; i < items.length; i++) wishlistIds.push(items[i].foodId);
                let cards = document.querySelectorAll('.food-card');
                for(let i = 0; i < cards.length; i++) {
                    let foodId = parseInt(cards[i].getAttribute('data-food-id'));
                    let heartIcon = cards[i].querySelector('.wishlist-btn i');
                    if(heartIcon) heartIcon.className = wishlistIds.includes(foodId) ? 'fas fa-heart' : 'far fa-heart';
                }
            })
            .catch(function(error) { console.error('Error:', error); });
    }

    function toggleWishlist(foodId, btn) {
        let icon = btn.querySelector('i');
        let action = icon.classList.contains('fas') ? 'remove' : 'add';
        fetch('WishlistServlet?action=' + action + '&foodId=' + foodId, { method: 'POST' })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if(data.success) {
                    if(action === 'add') {
                        icon.classList.remove('far');
                        icon.classList.add('fas');
                        showMessage('Added to wishlist ❤️', false);
                    } else {
                        icon.classList.remove('fas');
                        icon.classList.add('far');
                        showMessage('Removed from wishlist 💔', false);
                        if(document.getElementById('wishlistModal').style.display === 'flex') showWishlist();
                    }
                }
            })
            .catch(function() { showMessage('Error updating wishlist', true); });
    }
    
    function removeFromWishlist(foodId, foodName) {
        fetch('WishlistServlet?action=remove&foodId=' + foodId, { method: 'POST' })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if(data.success) {
                    showMessage(foodName + ' removed from wishlist 💔', false);
                    showWishlist();
                    loadWishlistStatus();
                }
            });
    }
    
    function showWishlist() {
        fetch('WishlistServlet')
            .then(function(response) { return response.json(); })
            .then(function(items) {
                let html = '';
                if(items.length === 0) {
                    html = '<div style="text-align:center; padding:40px;"><i class="far fa-heart" style="font-size:60px; color:#888;"></i><p style="margin-top:15px;">Your wishlist is empty</p></div>';
                } else {
                    html = '<div style="display:grid; gap:15px;">';
                    for(let i = 0; i < items.length; i++) {
                        html += '<div class="wishlist-item">' +
                            '<div><strong>' + items[i].name + '</strong><br><small style="color:#E4002B;">₹' + items[i].price + '</small></div>' +
                            '<div class="wishlist-actions">' +
                            '<button class="wishlist-add-cart" onclick="addToCart(' + items[i].foodId + ', \'' + items[i].name + '\', ' + items[i].price + '); closeWishlistModal();"><i class="fas fa-cart-plus"></i> Add to Cart</button>' +
                            '<button class="wishlist-remove" onclick="removeFromWishlist(' + items[i].foodId + ', \'' + items[i].name + '\')"><i class="fas fa-trash"></i> Remove</button>' +
                            '</div></div>';
                    }
                    html += '</div>';
                }
                document.getElementById('wishlistContent').innerHTML = html;
                document.getElementById('wishlistModal').style.display = 'flex';
            });
    }
    
    function closeWishlistModal() {
        document.getElementById('wishlistModal').style.display = 'none';
    }

    function logout() {
        if(orderRefreshInterval) clearInterval(orderRefreshInterval);
        if(trackInterval) clearInterval(trackInterval);
        window.location.href = 'UserAuthServlet?action=logout';
    }

    window.onclick = function(event) {
        if(event.target === document.getElementById('trackModal')) closeTrackModal();
        if(event.target === document.getElementById('wishlistModal')) closeWishlistModal();
        if(event.target === document.getElementById('reviewModal')) closeReviewModal();
        if(event.target === document.getElementById('reviewsModal')) closeReviewsModal();
        if(event.target === document.getElementById('customizeModal')) closeCustomizeModal();
    }

    updateCartCount();
    loadWishlistStatus();
</script>
</body>
</html>