<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.src.model.Food, com.src.model.Transaction, com.src.dao.FoodDAO, com.src.dao.TransactionDAO" %>
<%
    if(session.getAttribute("adminEmail") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
    
    FoodDAO foodDAO = new FoodDAO();
    TransactionDAO transactionDAO = new TransactionDAO();
    
    List<Food> foods = foodDAO.getAllFoodItems();
    List<Transaction> transactions = transactionDAO.getAllTransactions();
    
    int totalFoods = foods.size();
    int totalOrders = transactions.size();
    
    double totalRevenue = 0;
    for(Transaction t : transactions) {
        totalRevenue += t.getAmount();
    }
    
    int pendingOrders = 0;
    for(Transaction t : transactions) {
        String status = t.getOrderStatus();
        if(status == null) status = "Processing";
        if(!status.equals("Delivered")) {
            pendingOrders++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - SRC Fast Food</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background: #0a0a0a;
            color: white;
        }
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 280px;
            height: 100%;
            background: linear-gradient(180deg, #0a0a0a 0%, #1a1a1a 100%);
            border-right: 1px solid rgba(255,255,255,0.1);
            padding: 30px 20px;
            z-index: 100;
        }
        .sidebar-logo { text-align: center; margin-bottom: 40px; }
        .sidebar-logo .icon {
            width: 70px; height: 70px;
            background: #E4002B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 35px;
        }
        .sidebar-logo h2 { font-size: 20px; color: #E4002B; }
        .sidebar-logo p { font-size: 10px; color: #888; }
        .nav-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px 20px;
            margin: 10px 0;
            border-radius: 15px;
            cursor: pointer;
            transition: 0.3s;
            color: #888;
        }
        .nav-item:hover, .nav-item.active {
            background: rgba(228, 0, 43, 0.1);
            color: #E4002B;
        }
        .nav-item i { width: 25px; font-size: 18px; }
        .logout-item { position: absolute; bottom: 30px; width: calc(100% - 40px); }
        .main-content { margin-left: 280px; padding: 30px; }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: #111;
            border-radius: 20px;
            padding: 25px;
            transition: 0.3s;
            border: 1px solid rgba(255,255,255,0.05);
        }
        .stat-card:hover {
            transform: translateY(-5px);
            border-color: rgba(228, 0, 43, 0.3);
        }
        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .stat-icon {
            width: 50px;
            height: 50px;
            background: rgba(228, 0, 43, 0.1);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: #E4002B;
        }
        .stat-value { font-size: 32px; font-weight: 700; }
        .stat-label { color: #888; font-size: 14px; }
        
        .section {
            background: #111;
            border-radius: 20px;
            padding: 30px;
            margin-top: 30px;
            display: none;
        }
        .section.active { display: block; animation: fadeIn 0.4s ease; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }
        .section-header h2 { font-size: 24px; }
        
        .add-food-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
            padding: 20px;
            background: #1a1a1a;
            border-radius: 15px;
        }
        .add-food-form input, .add-food-form select {
            padding: 12px;
            background: #222;
            border: 1px solid #333;
            border-radius: 10px;
            color: white;
        }
        .btn-add {
            padding: 12px;
            background: #28a745;
            border: none;
            border-radius: 10px;
            color: white;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-export {
            padding: 10px 20px;
            background: #17a2b8;
            border: none;
            border-radius: 10px;
            color: white;
            cursor: pointer;
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
            overflow-x: auto;
            display: block;
        }
        .data-table th, .data-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #222;
        }
        .data-table th { color: #E4002B; font-weight: 600; }
        .delete-btn {
            background: #dc3545;
            border: none;
            padding: 6px 12px;
            border-radius: 8px;
            color: white;
            cursor: pointer;
        }
        .status-select {
            background: #222;
            border: 1px solid #333;
            border-radius: 8px;
            padding: 5px 10px;
            color: white;
            cursor: pointer;
        }
        
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        .chart-card {
            background: #1a1a1a;
            padding: 20px;
            border-radius: 15px;
        }
        .chart-card h3 {
            margin-bottom: 15px;
            color: #E4002B;
        }
        canvas { max-height: 300px; width: 100% !important; }
        
        @media (max-width: 768px) {
            .sidebar { width: 80px; padding: 20px 10px; }
            .sidebar-logo h2, .sidebar-logo p, .nav-item span { display: none; }
            .main-content { margin-left: 80px; }
            .nav-item { justify-content: center; }
            .charts-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-logo">
            <div class="icon">👑</div>
            <h2>SRC Admin</h2>
            <p>Dashboard</p>
        </div>
        <div class="nav-item active" onclick="showSection('dashboard')">
            <i class="fas fa-chart-line"></i>
            <span>Dashboard</span>
        </div>
        <div class="nav-item" onclick="showSection('food')">
            <i class="fas fa-utensils"></i>
            <span>Food Items (<%= totalFoods %>)</span>
        </div>
        <div class="nav-item" onclick="showSection('transactions')">
            <i class="fas fa-receipt"></i>
            <span>Orders (<%= totalOrders %>)</span>
        </div>
        <div class="nav-item logout-item" onclick="logout()">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </div>
    </div>

    <div class="main-content">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header"><div class="stat-icon"><i class="fas fa-utensils"></i></div></div>
                <div class="stat-value"><%= totalFoods %></div>
                <div class="stat-label">Total Food Items</div>
            </div>
            <div class="stat-card">
                <div class="stat-header"><div class="stat-icon"><i class="fas fa-shopping-cart"></i></div></div>
                <div class="stat-value"><%= totalOrders %></div>
                <div class="stat-label">Total Orders</div>
            </div>
            <div class="stat-card">
                <div class="stat-header"><div class="stat-icon"><i class="fas fa-rupee-sign"></i></div></div>
                <div class="stat-value">₹ <%= String.format("%.2f", totalRevenue) %></div>
                <div class="stat-label">Total Revenue</div>
            </div>
            <div class="stat-card">
                <div class="stat-header"><div class="stat-icon"><i class="fas fa-clock"></i></div></div>
                <div class="stat-value"><%= pendingOrders %></div>
                <div class="stat-label">Pending Orders</div>
            </div>
        </div>

        <!-- Dashboard Section -->
        <div id="dashboardSection" class="section active">
            <div class="section-header">
                <h2><i class="fas fa-chart-bar"></i> Analytics Dashboard</h2>
                <button class="btn-export" onclick="exportToExcel()"><i class="fas fa-file-excel"></i> Export Report</button>
            </div>
            <div class="charts-grid">
                <div class="chart-card">
                    <h3>Daily Sales (Last 7 Days)</h3>
                    <canvas id="salesChart"></canvas>
                </div>
                <div class="chart-card">
                    <h3>Popular Items</h3>
                    <canvas id="popularChart"></canvas>
                </div>
            </div>
            <div class="charts-grid">
                <div class="chart-card">
                    <h3>Category Distribution</h3>
                    <canvas id="categoryChart"></canvas>
                </div>
                <div class="chart-card">
                    <h3>Order Status</h3>
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Food Section -->
        <div id="foodSection" class="section">
            <div class="section-header">
                <h2><i class="fas fa-plus-circle"></i> Add New Food Item</h2>
            </div>
            <div class="add-food-form">
                <input type="text" id="foodName" placeholder="Food Name">
                <input type="text" id="foodCategory" placeholder="Category (e.g., Burgers, Pizza)">
                <select id="foodType">
                    <option value="Veg">Veg</option>
                    <option value="Non-Veg">Non-Veg</option>
                </select>
                <input type="number" id="foodPrice" placeholder="Price (₹)">
                <button class="btn-add" onclick="addFood()"><i class="fas fa-plus"></i> Add Item</button>
            </div>
            <div class="section-header">
                <h2><i class="fas fa-list"></i> All Food Items (<%= totalFoods %> items)</h2>
            </div>
            <div style="overflow-x: auto;">
                <table class="data-table">
                    <thead>
                        <tr><th>ID</th><th>Name</th><th>Category</th><th>Type</th><th>Price</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                        <% if(foods != null && !foods.isEmpty()) { 
                            for(Food food : foods) { %>
                            <tr>
                                <td><%= food.getFoodId() %></a></td>
                                <td><%= food.getName() %></a></td>
                                <td><%= food.getCategory() != null ? food.getCategory() : "-" %></a></td>
                                <td><%= food.getVegNonveg() != null ? food.getVegNonveg() : "-" %></a></td>
                                <td>₹ <%= String.format("%.2f", food.getPrice()) %></a></td>
                                <td><button class="delete-btn" onclick="deleteFood(<%= food.getFoodId() %>)"><i class="fas fa-trash"></i> Delete</button></a></td>
                            </tr>
                        <% } } else { %>
                            <tr><td colspan="6" style="text-align:center;">No food items found. Add some!</a></td>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Orders Section -->
        <div id="transactionsSection" class="section">
            <div class="section-header">
                <h2><i class="fas fa-history"></i> Order History (<%= totalOrders %> orders)</h2>
                <button class="btn-export" onclick="exportTransactions()"><i class="fas fa-download"></i> Export to Excel</button>
            </div>
            <div style="overflow-x: auto;">
                <table class="data-table">
                    <thead>
                        <tr><th>ID</th><th>Customer</th><th>Email</th><th>Items</th><th>Amount</th><th>Payment</th><th>Order Status</th><th>Date</th></tr>
                    </thead>
                    <tbody>
                        <% if(transactions != null && !transactions.isEmpty()) { 
                            for(Transaction t : transactions) { 
                                String orderStatus = t.getOrderStatus();
                                if(orderStatus == null || orderStatus.isEmpty()) orderStatus = "Processing";
                        %>
                            <tr>
                                <td>#<%= t.getTransactionId() %></a></td>
                                <td><%= t.getUserName() != null ? t.getUserName() : "Guest" %></a></td>
                                <td><%= t.getUserEmail() != null ? t.getUserEmail() : "-" %></a></td>
                                <td><%= t.getItems() != null ? t.getItems() : "-" %></a></td>
                                <td>₹ <%= String.format("%.2f", t.getAmount()) %></a></td>
                                <td><span style="background:#28a745; padding:4px 12px; border-radius:20px; font-size:12px;"><%= t.getPaymentStatus() != null ? t.getPaymentStatus() : "Success" %></span></a></td>
                                <td>
                                    <select class="status-select" onchange="updateOrderStatus(<%= t.getTransactionId() %>, this.value)">
                                        <option value="Processing" <%= orderStatus.equals("Processing") ? "selected" : "" %>>Processing</option>
                                        <option value="Preparing" <%= orderStatus.equals("Preparing") ? "selected" : "" %>>Preparing</option>
                                        <option value="Out for Delivery" <%= orderStatus.equals("Out for Delivery") ? "selected" : "" %>>Out for Delivery</option>
                                        <option value="Delivered" <%= orderStatus.equals("Delivered") ? "selected" : "" %>>Delivered</option>
                                    </select>
                                </a></td>
                                <td><%= t.getTransactionDate() != null ? t.getTransactionDate() : "-" %></a></td>
                            </tr>
                        <% } } else { %>
                            <tr><td colspan="8" style="text-align:center;">No orders found</a></td>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="messageBox" class="message"></div>

    <script>
        function showMessage(msg, isError) {
            var msgBox = document.getElementById('messageBox');
            msgBox.innerHTML = (isError ? '❌ ' : '✅ ') + msg;
            msgBox.style.background = isError ? '#dc3545' : '#28a745';
            msgBox.style.display = 'block';
            setTimeout(function() { msgBox.style.display = 'none'; }, 3000);
        }

        function showSection(section) {
            var items = document.querySelectorAll('.nav-item');
            for(var i = 0; i < items.length; i++) {
                items[i].classList.remove('active');
            }
            event.currentTarget.classList.add('active');
            
            document.getElementById('dashboardSection').classList.remove('active');
            document.getElementById('foodSection').classList.remove('active');
            document.getElementById('transactionsSection').classList.remove('active');
            
            if(section === 'dashboard') {
                document.getElementById('dashboardSection').classList.add('active');
                loadAllCharts();
            } else if(section === 'food') {
                document.getElementById('foodSection').classList.add('active');
            } else if(section === 'transactions') {
                document.getElementById('transactionsSection').classList.add('active');
            }
        }

        function loadAllCharts() {
            loadSalesChart();
            loadPopularChart();
            loadCategoryChart();
            loadStatusChart();
        }
        
        function loadSalesChart() {
            fetch('SalesDashboardServlet?action=dailySales')
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    var ctx = document.getElementById('salesChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'line',
                        data: { labels: data.dates || [], datasets: [{ label: 'Sales (₹)', data: data.amounts || [], borderColor: '#E4002B', backgroundColor: 'rgba(228,0,43,0.1)', tension: 0.4, fill: true }] },
                        options: { responsive: true, maintainAspectRatio: true }
                    });
                }).catch(function(error) { console.error('Error:', error); });
        }
        
        function loadPopularChart() {
            fetch('SalesDashboardServlet?action=popularItems')
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    var ctx = document.getElementById('popularChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'bar',
                        data: { labels: data.names || [], datasets: [{ label: 'Orders Count', data: data.counts || [], backgroundColor: '#FFC72C', borderRadius: 10 }] },
                        options: { responsive: true, maintainAspectRatio: true }
                    });
                }).catch(function(error) { console.error('Error:', error); });
        }
        
        function loadCategoryChart() {
            fetch('SalesDashboardServlet?action=categorySales')
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    var ctx = document.getElementById('categoryChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'doughnut',
                        data: { labels: data.categories || [], datasets: [{ data: data.totals || [], backgroundColor: ['#E4002B', '#FFC72C', '#28a745', '#17a2b8', '#fd7e14', '#6f42c1'] }] },
                        options: { responsive: true, maintainAspectRatio: true }
                    });
                }).catch(function(error) { console.error('Error:', error); });
        }
        
        function loadStatusChart() {
            fetch('SalesDashboardServlet?action=orderStatus')
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    var ctx = document.getElementById('statusChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'pie',
                        data: { labels: data.statuses || [], datasets: [{ data: data.counts || [], backgroundColor: ['#FFC72C', '#17a2b8', '#fd7e14', '#28a745'] }] },
                        options: { responsive: true, maintainAspectRatio: true }
                    });
                }).catch(function(error) { console.error('Error:', error); });
        }

        function addFood() {
            var name = document.getElementById('foodName').value;
            var category = document.getElementById('foodCategory').value;
            var type = document.getElementById('foodType').value;
            var price = document.getElementById('foodPrice').value;
            
            if(!name || !category || !price) {
                showMessage('Please fill all fields!', true);
                return;
            }
            
            var foodData = { name: name, category: category, vegNonveg: type, price: parseFloat(price) };
            
            fetch('FoodServlet?action=add', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(foodData)
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if(data.success || data.message) {
                    showMessage('Food item added successfully!', false);
                    setTimeout(function() { location.reload(); }, 1000);
                } else {
                    showMessage('Error adding food item!', true);
                }
            });
        }
        
        function deleteFood(id) {
            if(confirm('Are you sure you want to delete this item?')) {
                fetch('FoodServlet?action=delete&id=' + id, { method: 'DELETE' })
                    .then(function(response) { return response.json(); })
                    .then(function(data) {
                        if(data.success || data.message) {
                            showMessage('Food item deleted!', false);
                            setTimeout(function() { location.reload(); }, 1000);
                        }
                    });
            }
        }

        function updateOrderStatus(orderId, status) {
            fetch('UpdateOrderStatusServlet?orderId=' + orderId + '&status=' + status, { method: 'POST' })
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    if(data.success) {
                        showMessage('Order status updated successfully!', false);
                    }
                });
        }

        function exportToExcel() {
            window.location.href = 'ExportExcelServlet';
        }
        
        function exportTransactions() {
            window.location.href = 'ExportExcelServlet';
        }

        function logout() {
            window.location.href = 'AdminAuthServlet?action=logout';
        }

        loadAllCharts();
    </script>
</body>
</html>