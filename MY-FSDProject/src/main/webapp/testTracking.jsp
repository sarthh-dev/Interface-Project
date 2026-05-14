<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Test Order Tracking</title>
</head>
<body>
    <h1>Test Order Tracking Servlet</h1>
    
    <div>
        <label>Enter Transaction ID: </label>
        <input type="number" id="orderId" placeholder="e.g., 1">
        <button onclick="testTracking()">Test Tracking</button>
    </div>
    
    <div id="result" style="margin-top: 20px; padding: 10px; border: 1px solid #ccc;"></div>
    
    <script>
        function testTracking() {
            var orderId = document.getElementById('orderId').value;
            var resultDiv = document.getElementById('result');
            
            resultDiv.innerHTML = 'Loading...';
            
            fetch('OrderTrackingServlet?transactionId=' + orderId)
                .then(function(response) { 
                    return response.json(); 
                })
                .then(function(data) {
                    resultDiv.innerHTML = '<pre>' + JSON.stringify(data, null, 2) + '</pre>';
                })
                .catch(function(error) {
                    resultDiv.innerHTML = 'Error: ' + error.message;
                });
        }
    </script>
</body>
</html>