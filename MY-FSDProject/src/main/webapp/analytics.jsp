<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("userEmail") == null && session.getAttribute("adminEmail") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String userRole = session.getAttribute("adminEmail") != null ? "admin" : "user";
    String userName = (String) session.getAttribute("userName");
    if(userName == null) userName = (String) session.getAttribute("userEmail");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics Dashboard - SRC Fast Food</title>
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
        .nav-links a, .nav-links button {
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
        .nav-links a:hover, .nav-links button:hover {
            background: rgba(228, 0, 43, 0.2);
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 5%;
        }
        .page-header {
            margin-bottom: 30px;
        }
        .page-header h2 {
            font-size: 32px;
            color: #E4002B;
        }
        .period-selector {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
            background: #111;
            padding: 15px;
            border-radius: 50px;
        }
        .period-btn {
            padding: 10px 25px;
            background: transparent;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 50px;
            color: white;
            cursor: pointer;
            transition: 0.3s;
        }
        .period-btn.active, .period-btn:hover {
            background: #E4002B;
            border-color: #E4002B;
        }
        .export-btns {
            display: flex;
            gap: 10px;
            margin-left: auto;
        }
        .export-btn {
            padding: 10px 20px;
            background: #28a745;
            border: none;
            border-radius: 50px;
            color: white;
            cursor: pointer;
        }
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }
        .chart-card {
            background: #111;
            border-radius: 20px;
            padding: 20px;
            border: 1px solid rgba(255,255,255,0.05);
        }
        .chart-card h3 {
            margin-bottom: 20px;
            color: #FFC72C;
        }
        canvas {
            max-height: 300px;
            width: 100% !important;
        }
        .transactions-section {
            background: #111;
            border-radius: 20px;
            padding: 30px;
            margin-top: 30px;
        }
        .transactions-section h3 {
            margin-bottom: 20px;
            color: #FFC72C;
        }
        .sort-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .sort-btn {
            padding: 8px 20px;
            background: #222;
            border: 1px solid #333;
            border-radius: 25px;
            color: white;
            cursor: pointer;
        }
        .sort-btn.active {
            background: #E4002B;
            border-color: #E4002B;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            overflow-x: auto;
            display: block;
        }
        .data-table th, .data-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #222;
        }
        .data-table th {
            color: #E4002B;
            font-weight: 600;
        }
        .stats-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-box {
            background: #111;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.05);
        }
        .stat-box h4 {
            color: #888;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .stat-box .value {
            font-size: 28px;
            font-weight: bold;
            color: #E4002B;
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
        }
        @media (max-width: 768px) {
            .charts-grid { grid-template-columns: 1fr; }
            .period-selector { flex-direction: column; border-radius: 20px; }
            .export-btns { margin-left: 0; margin-top: 10px; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="logo">
        <div class="logo-icon">📊</div>
        <h1>SRC FAST FOOD</h1>
    </div>
    <div class="nav-links">
        <% if("admin".equals(userRole)) { %>
            <a href="adminDashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <% } else { %>
            <a href="userDashboard.jsp"><i class="fas fa-home"></i> Home</a>
        <% } %>
        <a href="analytics.jsp" style="background:#E4002B;"><i class="fas fa-chart-line"></i> Analytics</a>
        <button onclick="logout()"><i class="fas fa-sign-out-alt"></i> Logout</button>
    </div>
</nav>

<div class="container">
    <div class="page-header">
        <h2><i class="fas fa-chart-line"></i> Advanced Analytics Dashboard</h2>
        <p>Real-time insights and reports for <%= userName %></p>
    </div>

    <!-- Period Selector -->
    <div class="period-selector">
        <button class="period-btn active" onclick="setPeriod('all')">All Time</button>
        <button class="period-btn" onclick="setPeriod('weekly')">Last 7 Days</button>
        <button class="period-btn" onclick="setPeriod('monthly')">Last 30 Days</button>
        <button class="period-btn" onclick="setPeriod('yearly')">Last 365 Days</button>
        <div class="export-btns">
            <button class="export-btn" onclick="exportPDF('transactions')"><i class="fas fa-file-pdf"></i> Export Transactions</button>
            <button class="export-btn" onclick="exportPDF('bestSelling')"><i class="fas fa-chart-simple"></i> Export Best Selling</button>
            <button class="export-btn" onclick="exportPDF('customerSpending')"><i class="fas fa-users"></i> Export Customers</button>
            <button class="export-btn" onclick="exportPDF('summary')"><i class="fas fa-file-alt"></i> Export Summary</button>
        </div>
    </div>

    <!-- Stats Summary -->
    <div class="stats-summary" id="statsSummary">
        <div class="stat-box"><h4>Total Orders</h4><div class="value" id="totalOrders">-</div></div>
        <div class="stat-box"><h4>Total Revenue</h4><div class="value" id="totalRevenue">-</div></div>
        <div class="stat-box"><h4>Avg Order Value</h4><div class="value" id="avgOrderValue">-</div></div>
        <div class="stat-box"><h4>Active Customers</h4><div class="value" id="activeCustomers">-</div></div>
    </div>

    <!-- Charts Grid -->
    <div class="charts-grid">
        <div class="chart-card">
            <h3><i class="fas fa-trophy"></i> Best Selling Items</h3>
            <canvas id="bestSellingChart"></canvas>
        </div>
        <div class="chart-card">
            <h3><i class="fas fa-clock"></i> Peak Ordering Hours</h3>
            <canvas id="peakHoursChart"></canvas>
        </div>
    </div>
    <div class="charts-grid">
        <div class="chart-card">
            <h3><i class="fas fa-chart-line"></i> Monthly Sales Report</h3>
            <canvas id="monthlyReportChart"></canvas>
        </div>
        <div class="chart-card">
            <h3><i class="fas fa-chart-pie"></i> Yearly Sales Report</h3>
            <canvas id="yearlyReportChart"></canvas>
        </div>
    </div>

    <!-- Customer Spending Insights -->
    <div class="chart-card" style="margin-bottom: 30px;">
        <h3><i class="fas fa-users"></i> Top Customers by Spending</h3>
        <canvas id="customerSpendingChart" style="max-height: 400px;"></canvas>
    </div>

    <!-- Transactions with Sorting -->
    <div class="transactions-section">
        <h3><i class="fas fa-receipt"></i> Transaction History</h3>
        <div class="sort-buttons">
            <button class="sort-btn active" onclick="sortTransactions('all')">All Time</button>
            <button class="sort-btn" onclick="sortTransactions('weekly')">Last 7 Days</button>
            <button class="sort-btn" onclick="sortTransactions('monthly')">Last 30 Days</button>
            <button class="sort-btn" onclick="sortTransactions('yearly')">Last 365 Days</button>
        </div>
        <div style="overflow-x: auto;">
            <table class="data-table">
                <thead>
                    <tr><th>Order ID</th><th>Customer</th><th>Email</th><th>Items</th><th>Amount</th><th>Status</th><th>Date</th></tr>
                </thead>
                <tbody id="transactionsTableBody">
                    <tr><td colspan="7" style="text-align:center;">Loading...</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="messageBox" class="message"></div>

<script>
    let currentPeriod = 'all';
    let currentSort = 'all';
    let charts = {};

    function showMessage(msg, isError) {
        let msgBox = document.getElementById('messageBox');
        msgBox.innerHTML = (isError ? '❌ ' : '✅ ') + msg;
        msgBox.style.background = isError ? '#dc3545' : '#28a745';
        msgBox.style.display = 'block';
        setTimeout(() => { msgBox.style.display = 'none'; }, 3000);
    }

    function setPeriod(period) {
        currentPeriod = period;
        document.querySelectorAll('.period-btn').forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');
        loadAllAnalytics();
    }

    function sortTransactions(sortBy) {
        currentSort = sortBy;
        document.querySelectorAll('.sort-btn').forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');
        loadTransactions();
    }

    function loadAllAnalytics() {
        loadBestSellingItems();
        loadPeakHours();
        loadMonthlyReport();
        loadYearlyReport();
        loadCustomerSpending();
        loadTransactions();
        loadStatsSummary();
    }

    function loadStatsSummary() {
        fetch('AnalyticsServlet?action=summary&period=' + currentPeriod)
            .then(response => response.json())
            .then(data => {
                document.getElementById('totalOrders').innerText = data.totalOrders || '0';
                document.getElementById('totalRevenue').innerText = '₹' + (data.totalRevenue || '0');
                document.getElementById('avgOrderValue').innerText = '₹' + (data.avgOrderValue || '0');
                document.getElementById('activeCustomers').innerText = data.activeCustomers || '0';
            })
            .catch(error => console.error('Error:', error));
    }

    function loadBestSellingItems() {
        fetch('AnalyticsServlet?action=bestSellingItems&period=' + currentPeriod)
            .then(response => response.json())
            .then(data => {
                let ctx = document.getElementById('bestSellingChart').getContext('2d');
                if(charts.bestSelling) charts.bestSelling.destroy();
                charts.bestSelling = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.items || [],
                        datasets: [{ label: 'Orders Count', data: data.counts || [], backgroundColor: '#E4002B', borderRadius: 10 }]
                    },
                    options: { responsive: true, maintainAspectRatio: true, plugins: { legend: { labels: { color: 'white' } } } }
                });
            });
    }

    function loadPeakHours() {
        fetch('AnalyticsServlet?action=peakHours&period=' + currentPeriod)
            .then(response => response.json())
            .then(data => {
                let ctx = document.getElementById('peakHoursChart').getContext('2d');
                if(charts.peakHours) charts.peakHours.destroy();
                charts.peakHours = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: data.hours || [],
                        datasets: [{ label: 'Orders Count', data: data.orderCounts || [], borderColor: '#FFC72C', backgroundColor: 'rgba(255,199,44,0.1)', tension: 0.4, fill: true }]
                    },
                    options: { responsive: true, maintainAspectRatio: true, plugins: { legend: { labels: { color: 'white' } } } }
                });
            });
    }

    function loadMonthlyReport() {
        fetch('AnalyticsServlet?action=monthlyReport')
            .then(response => response.json())
            .then(data => {
                let ctx = document.getElementById('monthlyReportChart').getContext('2d');
                if(charts.monthly) charts.monthly.destroy();
                charts.monthly = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.months || [],
                        datasets: [
                            { label: 'Sales (₹)', data: data.sales || [], backgroundColor: '#E4002B', borderRadius: 10, yAxisID: 'y' },
                            { label: 'Orders', data: data.orders || [], backgroundColor: '#FFC72C', borderRadius: 10, yAxisID: 'y1' }
                        ]
                    },
                    options: {
                        responsive: true, maintainAspectRatio: true,
                        plugins: { legend: { labels: { color: 'white' } } },
                        scales: { y: { title: { display: true, text: 'Sales (₹)', color: 'white' }, ticks: { color: 'white' } }, y1: { position: 'right', title: { display: true, text: 'Orders', color: 'white' }, ticks: { color: 'white' }, grid: { drawOnChartArea: false } } }
                    }
                });
            });
    }

    function loadYearlyReport() {
        fetch('AnalyticsServlet?action=yearlyReport')
            .then(response => response.json())
            .then(data => {
                let ctx = document.getElementById('yearlyReportChart').getContext('2d');
                if(charts.yearly) charts.yearly.destroy();
                charts.yearly = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: data.years || [],
                        datasets: [
                            { label: 'Sales (₹)', data: data.sales || [], borderColor: '#E4002B', backgroundColor: 'rgba(228,0,43,0.1)', tension: 0.4, fill: true },
                            { label: 'Orders', data: data.orders || [], borderColor: '#FFC72C', backgroundColor: 'rgba(255,199,44,0.1)', tension: 0.4, fill: true }
                        ]
                    },
                    options: { responsive: true, maintainAspectRatio: true, plugins: { legend: { labels: { color: 'white' } } }, scales: { y: { ticks: { color: 'white' } }, x: { ticks: { color: 'white' } } } }
                });
            });
    }

    function loadCustomerSpending() {
        fetch('AnalyticsServlet?action=customerSpending&period=' + currentPeriod)
            .then(response => response.json())
            .then(data => {
                let ctx = document.getElementById('customerSpendingChart').getContext('2d');
                if(charts.customerSpending) charts.customerSpending.destroy();
                charts.customerSpending = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.customers || [],
                        datasets: [
                            { label: 'Total Spent (₹)', data: data.totalSpent || [], backgroundColor: '#E4002B', borderRadius: 10, yAxisID: 'y' },
                            { label: 'Orders Count', data: data.orderCounts || [], backgroundColor: '#FFC72C', borderRadius: 10, yAxisID: 'y1' }
                        ]
                    },
                    options: {
                        responsive: true, maintainAspectRatio: true, indexAxis: 'y',
                        plugins: { legend: { labels: { color: 'white' } } },
                        scales: { y: { ticks: { color: 'white' } }, x: { ticks: { color: 'white' } } }
                    }
                });
            });
    }

    function loadTransactions() {
        fetch('AnalyticsServlet?action=sortTransactions&sortBy=' + currentSort)
            .then(response => response.json())
            .then(data => {
                let html = '';
                if(data.transactions && data.transactions.length > 0) {
                    for(let i = 0; i < data.transactions.length; i++) {
                        let t = data.transactions[i];
                        let statusColor = t.orderStatus === 'Delivered' ? '#28a745' : (t.orderStatus === 'Processing' ? '#FFC72C' : '#17a2b8');
                        html += '<tr>' +
                            '<td>#' + t.transactionId + '</a></td> +
                            '<td>' + t.userName + '</a></td> +
                            '<td>' + t.userEmail + '</a></td> +
                            '<td>' + (t.items.length > 30 ? t.items.substring(0,27) + '...' : t.items) + '</a></td> +
                            '<td>₹' + parseFloat(t.amount).toFixed(2) + '</a></td> +
                            '<td><span style="color:' + statusColor + ';">' + t.orderStatus + '</span></a></td> +
                            '<td>' + t.transactionDate + '</a></td> +
                            '</tr>';
                    }
                } else {
                    html = '<tr><td colspan="7" style="text-align:center;">No transactions found</a></tr>';
                }
                document.getElementById('transactionsTableBody').innerHTML = html;
            });
    }

    function exportPDF(type) {
        window.open('ExportPDFServlet?type=' + type + '&period=' + currentPeriod, '_blank');
        showMessage('Exporting PDF report...', false);
    }

    function logout() {
        <% if("admin".equals(userRole)) { %>
            window.location.href = 'AdminAuthServlet?action=logout';
        <% } else { %>
            window.location.href = 'UserAuthServlet?action=logout';
        <% } %>
    }

    loadAllAnalytics();
</script>
</body>
</html>