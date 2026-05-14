<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("userEmail") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart - SRC Fast Food</title>
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
            border-bottom: 1px solid rgba(255,255,255,0.1);
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
        .logo h1 { font-size: 24px; color: #E4002B; }
        .back-btn {
            background: rgba(255,255,255,0.1);
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            color: white;
            cursor: pointer;
            text-decoration: none;
        }
        .cart-container { max-width: 1200px; margin: 2rem auto; padding: 0 5%; }
        .cart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .cart-header h2 { font-size: 32px; }
        .cart-header h2 i { color: #E4002B; margin-right: 10px; }
        .cart-items { background: #111; border-radius: 20px; overflow: hidden; }
        .cart-item {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 0.5fr;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #222;
        }
        .item-info h4 { font-size: 18px; margin-bottom: 5px; color: white; }
        .item-info p { color: #888; font-size: 14px; }
        .item-price { font-size: 18px; font-weight: 600; color: #E4002B; }
        .item-quantity { display: flex; align-items: center; gap: 15px; }
        .qty-btn {
            width: 35px; height: 35px;
            background: #222; border: none; border-radius: 10px;
            color: white; font-size: 18px; cursor: pointer;
        }
        .qty-btn:hover { background: #E4002B; }
        .item-total { font-size: 18px; font-weight: 700; color: #FFC72C; }
        .remove-btn { background: none; border: none; color: #dc3545; font-size: 20px; cursor: pointer; }
        .cart-summary { margin-top: 2rem; background: #111; border-radius: 20px; padding: 30px; }
        .summary-row { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid #222; }
        .summary-row.total { font-size: 24px; font-weight: 700; color: #E4002B; border-bottom: none; padding-top: 20px; }
        .checkout-btn {
            width: 100%; padding: 18px;
            background: linear-gradient(135deg, #28a745, #218838);
            border: none; border-radius: 15px; color: white;
            font-size: 18px; font-weight: 700; cursor: pointer;
            margin-top: 20px;
        }
        .checkout-btn:hover { transform: translateY(-2px); }
        .empty-cart { text-align: center; padding: 60px; background: #111; border-radius: 20px; }
        .empty-cart i { font-size: 80px; color: #888; margin-bottom: 20px; }
        .shop-btn {
            display: inline-block; margin-top: 20px; padding: 12px 30px;
            background: #E4002B; border-radius: 25px; color: white; text-decoration: none;
        }
        .coupon-section { margin: 20px 0; padding: 20px; background: #1a1a1a; border-radius: 15px; }
        .coupon-section h4 { margin-bottom: 10px; }
        .coupon-input { display: flex; gap: 10px; }
        .coupon-input input {
            flex: 1; padding: 12px; background: #222;
            border: 1px solid #333; border-radius: 10px; color: white;
        }
        .apply-btn {
            padding: 12px 25px; background: #FFC72C;
            border: none; border-radius: 10px; color: #222;
            font-weight: bold; cursor: pointer;
        }
        @media (max-width: 768px) {
            .cart-item { grid-template-columns: 1fr; gap: 15px; text-align: center; }
            .item-quantity { justify-content: center; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="logo">
        <div class="logo-icon">🛒</div>
        <h1>SRC FAST FOOD</h1>
    </div>
    <a href="userDashboard.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Continue Shopping</a>
</nav>

<div class="cart-container">
    <div class="cart-header">
        <h2><i class="fas fa-shopping-cart"></i> Your Cart</h2>
    </div>
    <div id="cartContent"></div>
</div>

<script>
    // Function to update cart count
    function updateCartCount() {
        var cart = JSON.parse(localStorage.getItem('cart') || '[]');
        var count = 0;
        for(var i = 0; i < cart.length; i++) {
            count += cart[i].quantity;
        }
        localStorage.setItem('cartCount', count);
    }
    
    // Function to format price
    function formatPrice(price) {
        return parseFloat(price).toFixed(2);
    }
    
    // Load cart and display
    function loadCart() {
        var cart = JSON.parse(localStorage.getItem('cart') || '[]');
        var cartContent = document.getElementById('cartContent');
        
        if(cart.length === 0) {
            cartContent.innerHTML = `
                <div class="empty-cart">
                    <i class="fas fa-shopping-cart"></i>
                    <h3>Your cart is empty!</h3>
                    <p>Looks like you haven't added any items yet.</p>
                    <a href="userDashboard.jsp" class="shop-btn">Browse Menu</a>
                </div>
            `;
            return;
        }
        
        var itemsHtml = '<div class="cart-items">';
        var subtotal = 0;
        
        for(var i = 0; i < cart.length; i++) {
            var item = cart[i];
            var itemTotal = item.price * item.quantity;
            subtotal += itemTotal;
            
            itemsHtml += `
                <div class="cart-item" data-index="` + i + `">
                    <div class="item-info">
                        <h4>` + item.name + `</h4>
                        <p>₹` + formatPrice(item.price) + ` each</p>
                    </div>
                    <div class="item-price">₹` + formatPrice(item.price) + `</div>
                    <div class="item-quantity">
                        <button class="qty-btn" onclick="updateQuantity(` + i + `, -1)">-</button>
                        <span style="min-width: 30px; text-align: center;">` + item.quantity + `</span>
                        <button class="qty-btn" onclick="updateQuantity(` + i + `, 1)">+</button>
                    </div>
                    <div class="item-total">₹` + formatPrice(itemTotal) + `</div>
                    <button class="remove-btn" onclick="removeItem(` + i + `)"><i class="fas fa-trash"></i></button>
                </div>
            `;
        }
        
        itemsHtml += '</div>';
        
        // Calculate delivery charge
        var deliveryCharge = subtotal > 200 ? 0 : 40;
        var total = subtotal + deliveryCharge;
        
        itemsHtml += `
            <div class="cart-summary">
                <div class="coupon-section">
                    <h4><i class="fas fa-tag"></i> Apply Coupon</h4>
                    <div class="coupon-input">
                        <input type="text" id="couponCode" placeholder="Enter coupon code (SRC20, WELCOME50)">
                        <button class="apply-btn" onclick="applyCoupon()">Apply</button>
                    </div>
                    <div id="couponMessage" style="margin-top: 10px; font-size: 12px;"></div>
                </div>
                
                <div class="summary-row">
                    <span>Subtotal</span>
                    <span>₹` + formatPrice(subtotal) + `</span>
                </div>
                <div class="summary-row">
                    <span>Delivery Charge</span>
                    <span>₹` + formatPrice(deliveryCharge) + `</span>
                </div>
                <div class="summary-row total">
                    <span>Total Amount</span>
                    <span>₹` + formatPrice(total) + `</span>
                </div>
                
                <button class="checkout-btn" onclick="proceedToCheckout(` + total + `)">
                    <i class="fas fa-credit-card"></i> Proceed to Checkout
                </button>
            </div>
        `;
        
        cartContent.innerHTML = itemsHtml;
        updateCartCount();
    }
    
    // Update quantity
    function updateQuantity(index, change) {
        var cart = JSON.parse(localStorage.getItem('cart') || '[]');
        var newQuantity = cart[index].quantity + change;
        
        if(newQuantity <= 0) {
            cart.splice(index, 1);
        } else {
            cart[index].quantity = newQuantity;
        }
        
        localStorage.setItem('cart', JSON.stringify(cart));
        loadCart();
    }
    
    // Remove item
    function removeItem(index) {
        var cart = JSON.parse(localStorage.getItem('cart') || '[]');
        cart.splice(index, 1);
        localStorage.setItem('cart', JSON.stringify(cart));
        loadCart();
    }
    
    // Apply coupon
    var appliedDiscount = 0;
    var finalTotal = 0;
    
    function applyCoupon() {
        var couponCode = document.getElementById('couponCode').value;
        var cart = JSON.parse(localStorage.getItem('cart') || '[]');
        var subtotal = 0;
        for(var i = 0; i < cart.length; i++) {
            subtotal += cart[i].price * cart[i].quantity;
        }
        
        fetch('CouponServlet?code=' + couponCode + '&amount=' + subtotal)
            .then(function(response) { return response.json(); })
            .then(function(data) {
                var msgDiv = document.getElementById('couponMessage');
                if(data.valid) {
                    appliedDiscount = data.discount;
                    finalTotal = data.finalAmount;
                    msgDiv.innerHTML = '<span style="color: #28a745;"><i class="fas fa-check-circle"></i> ' + data.message + '</span>';
                    
                    // Update total display
                    var deliveryCharge = finalTotal > 200 ? 0 : 40;
                    var grandTotal = finalTotal + deliveryCharge;
                    
                    // Update the total in the DOM
                    var totalSpan = document.querySelector('.summary-row.total span:last-child');
                    if(totalSpan) {
                        totalSpan.innerHTML = '₹' + formatPrice(grandTotal);
                    }
                    
                    // Store discount info
                    sessionStorage.setItem('appliedDiscount', appliedDiscount);
                    sessionStorage.setItem('finalTotal', finalTotal);
                } else {
                    msgDiv.innerHTML = '<span style="color: #dc3545;"><i class="fas fa-times-circle"></i> ' + data.message + '</span>';
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                document.getElementById('couponMessage').innerHTML = '<span style="color: #dc3545;">Error applying coupon</span>';
            });
    }
    
    // Proceed to checkout
    function proceedToCheckout(totalAmount) {
        var cart = JSON.parse(localStorage.getItem('cart') || '[]');
        
        if(cart.length === 0) {
            alert('Your cart is empty!');
            return;
        }
        
        // Create items list string
        var itemsList = "";
        for(var i = 0; i < cart.length; i++) {
            if(i > 0) itemsList += ", ";
            itemsList += cart[i].name + " x" + cart[i].quantity;
        }
        
        // Store order details in sessionStorage
        sessionStorage.setItem('orderTotal', totalAmount);
        sessionStorage.setItem('orderItems', itemsList);
        sessionStorage.setItem('cartData', JSON.stringify(cart));
        
        // Debug - check if values are stored
        console.log("Total Amount: " + totalAmount);
        console.log("Items: " + itemsList);
        
        // Redirect to payment page
        window.location.href = 'payment.jsp';
    }
    
    // Format price helper
    function formatPrice(price) {
        return parseFloat(price).toFixed(2);
    }
    
    // Load cart when page loads
    loadCart();
</script>
</body>
</html>