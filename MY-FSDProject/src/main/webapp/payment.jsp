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
    <title>Payment - SRC Fast Food</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0a0a0a 0%, #1a1a2e 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .payment-container { max-width: 550px; width: 100%; }
        .payment-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 30px;
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .payment-header { text-align: center; margin-bottom: 30px; }
        .payment-header h2 { color: white; font-size: 28px; }
        .order-summary {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            padding: 20px;
            margin-bottom: 30px;
        }
        .order-summary h3 { color: white; margin-bottom: 15px; font-size: 18px; }
        .order-items {
            color: #ccc;
            font-size: 14px;
            margin-bottom: 15px;
            line-height: 1.6;
            word-break: break-word;
        }
        .total-amount {
            font-size: 32px;
            font-weight: 700;
            color: #E4002B;
            text-align: center;
            padding: 15px;
            background: rgba(228, 0, 43, 0.1);
            border-radius: 15px;
            margin-top: 15px;
        }
        .payment-methods { margin-bottom: 30px; }
        .payment-methods h3 { color: white; margin-bottom: 15px; font-size: 18px; }
        .method {
            display: flex;
            align-items: center;
            padding: 15px;
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid transparent;
            border-radius: 15px;
            margin-bottom: 10px;
            cursor: pointer;
        }
        .method:hover { background: rgba(255, 255, 255, 0.1); }
        .method.selected { border-color: #E4002B; background: rgba(228, 0, 43, 0.1); }
        .method input { margin-right: 15px; transform: scale(1.2); }
        .method-icon {
            width: 40px; height: 40px;
            background: #222; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            margin-right: 15px; font-size: 20px;
        }
        .method-info { flex: 1; }
        .method-info h4 { color: white; font-size: 16px; }
        .method-info p { color: #888; font-size: 12px; }
        .pay-btn {
            width: 100%; padding: 18px;
            background: linear-gradient(135deg, #28a745, #218838);
            border: none; border-radius: 15px;
            color: white; font-size: 18px; font-weight: 700;
            cursor: pointer; margin-top: 20px;
        }
        .pay-btn:hover { transform: translateY(-2px); }
        .pay-btn:disabled { opacity: 0.6; cursor: not-allowed; }
        .back-link { text-align: center; margin-top: 20px; }
        .back-link a { color: #888; text-decoration: none; }
        .loader {
            display: inline-block;
            width: 20px; height: 20px;
            border: 3px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
            margin-right: 10px;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body>
    <div class="payment-container">
        <div class="payment-card">
            <div class="payment-header">
                <h2><i class="fas fa-credit-card"></i> Payment</h2>
                <p>Complete your order securely</p>
            </div>

            <div class="order-summary">
                <h3><i class="fas fa-receipt"></i> Order Summary</h3>
                <div class="order-items" id="orderItems">Loading...</div>
                <div class="total-amount">₹<span id="totalAmount">0</span></div>
            </div>

            <div class="payment-methods">
                <h3><i class="fas fa-wallet"></i> Select Payment Method</h3>
                
                <div class="method selected" onclick="selectMethod(this)">
                    <input type="radio" name="payment" value="Credit Card" checked>
                    <div class="method-icon"><i class="fas fa-credit-card"></i></div>
                    <div class="method-info">
                        <h4>Credit Card</h4>
                        <p>Pay with credit card</p>
                    </div>
                </div>

                <div class="method" onclick="selectMethod(this)">
                    <input type="radio" name="payment" value="Debit Card">
                    <div class="method-icon"><i class="fas fa-credit-card"></i></div>
                    <div class="method-info">
                        <h4>Debit Card</h4>
                        <p>Pay with debit card</p>
                    </div>
                </div>

                <div class="method" onclick="selectMethod(this)">
                    <input type="radio" name="payment" value="UPI">
                    <div class="method-icon"><i class="fas fa-mobile-alt"></i></div>
                    <div class="method-info">
                        <h4>UPI</h4>
                        <p>Google Pay, PhonePe, Paytm</p>
                    </div>
                </div>

                <div class="method" onclick="selectMethod(this)">
                    <input type="radio" name="payment" value="Cash on Delivery">
                    <div class="method-icon"><i class="fas fa-money-bill-wave"></i></div>
                    <div class="method-info">
                        <h4>Cash on Delivery</h4>
                        <p>Pay when you receive</p>
                    </div>
                </div>
            </div>

            <button class="pay-btn" onclick="processPayment()">Pay Now</button>

            <div class="back-link">
                <a href="cart.jsp"><i class="fas fa-arrow-left"></i> Back to Cart</a>
            </div>
        </div>
    </div>

    <script>
        // Get order details from sessionStorage
        var totalAmount = sessionStorage.getItem('orderTotal');
        var orderItems = sessionStorage.getItem('orderItems');
        
        console.log("Total from sessionStorage: " + totalAmount);
        console.log("Items from sessionStorage: " + orderItems);
        
        // Check if data exists
        if(!totalAmount || totalAmount == 'null' || totalAmount == 0 || totalAmount == '0') {
            document.getElementById('orderItems').innerHTML = '<span style="color:#dc3545;">Error: No order data found. Please go back to cart.</span>';
            document.getElementById('totalAmount').innerText = '0';
            document.querySelector('.pay-btn').disabled = true;
        } else {
            document.getElementById('orderItems').innerHTML = orderItems || 'No items';
            document.getElementById('totalAmount').innerText = parseFloat(totalAmount).toFixed(2);
        }
        
        function selectMethod(element) {
            var methods = document.getElementsByClassName('method');
            for(var i = 0; i < methods.length; i++) {
                methods[i].classList.remove('selected');
                var radio = methods[i].querySelector('input');
                if(radio) radio.checked = false;
            }
            element.classList.add('selected');
            var radio = element.querySelector('input');
            if(radio) radio.checked = true;
        }
        
        function processPayment() {
            var total = sessionStorage.getItem('orderTotal');
            var items = sessionStorage.getItem('orderItems');
            
            // Double check data
            if(!total || total == 'null' || total == 0 || total == '0') {
                alert('Error: No order data found! Please go back to cart and try again.');
                window.location.href = 'cart.jsp';
                return;
            }
            
            var selected = document.querySelector('input[name="payment"]:checked');
            var paymentMethod = selected ? selected.value : 'Credit Card';
            
            var btn = document.querySelector('.pay-btn');
            btn.innerHTML = '<span class="loader"></span> Processing...';
            btn.disabled = true;
            
            var orderData = {
                amount: parseFloat(total),
                items: items,
                paymentMethod: paymentMethod
            };
            
            console.log("Sending order data:", orderData);
            
            fetch('TransactionServlet?action=saveOrder', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(orderData)
            })
            .then(function(response) { 
                if(!response.ok) {
                    throw new Error('Server responded with status ' + response.status);
                }
                return response.json(); 
            })
            .then(function(data) {
                console.log("Response:", data);
                if(data.success) {
                    // Clear cart and session data
                    localStorage.removeItem('cart');
                    sessionStorage.removeItem('orderTotal');
                    sessionStorage.removeItem('orderItems');
                    sessionStorage.removeItem('cartData');
                    
                    // Download receipt
                    window.location.href = 'GenerateReceiptServlet?transactionId=' + data.transactionId;
                    
                    setTimeout(function() {
                        alert('✅ Payment Successful! Your receipt is being downloaded.');
                        window.location.href = 'userDashboard.jsp';
                    }, 2000);
                } else {
                    alert('Payment failed: ' + (data.error || 'Unknown error'));
                    btn.innerHTML = 'Pay Now';
                    btn.disabled = false;
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                alert('Payment failed! Please try again. Error: ' + error.message);
                btn.innerHTML = 'Pay Now';
                btn.disabled = false;
            });
        }
    </script>
</body>
</html>