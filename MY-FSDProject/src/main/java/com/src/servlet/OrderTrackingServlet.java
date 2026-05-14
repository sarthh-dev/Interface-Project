package com.src.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;
import com.src.dao.DBConnection;

@WebServlet("/OrderTrackingServlet")
public class OrderTrackingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Method to calculate actual status based on time
    private String calculateActualStatus(String dbStatus, Timestamp orderDate) {
        if ("Delivered".equals(dbStatus)) {
            return "Delivered";
        }
        if ("Cancelled".equals(dbStatus)) {
            return "Cancelled";
        }
        
        if (orderDate != null) {
            Timestamp now = new Timestamp(System.currentTimeMillis());
            long diffInMinutes = TimeUnit.MILLISECONDS.toMinutes(now.getTime() - orderDate.getTime());
            
            // Auto status based on time passed:
            // 0-20 min: Processing
            // 20-40 min: Preparing  
            // 40-60 min: Out for Delivery
            // 60+ min: Delivered
            
            if (diffInMinutes >= 60) {
                return "Delivered";
            } else if (diffInMinutes >= 40) {
                return "Out for Delivery";
            } else if (diffInMinutes >= 20) {
                return "Preparing";
            } else {
                return "Processing";
            }
        }
        return dbStatus != null ? dbStatus : "Processing";
    }
    
    private String calculateEstimatedDelivery(String status, Timestamp orderDate, boolean isDelivered) {
        if (isDelivered || "Delivered".equals(status)) {
            return "Order Delivered";
        }
        
        if (orderDate == null) return "30-40 minutes";
        
        Timestamp now = new Timestamp(System.currentTimeMillis());
        long diffInMinutes = TimeUnit.MILLISECONDS.toMinutes(now.getTime() - orderDate.getTime());
        
        if (diffInMinutes >= 60) {
            return "Delivered";
        } else if (diffInMinutes >= 40) {
            long remaining = 60 - diffInMinutes;
            return "Arriving in " + remaining + " minutes";
        } else if (diffInMinutes >= 20) {
            long remaining = 40 - diffInMinutes;
            return "Preparing - Ready in " + remaining + " minutes";
        } else {
            long remaining = 20 - diffInMinutes;
            return "Order confirmed - Ready in " + remaining + " minutes";
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        
        if (userEmail == null) {
            JSONObject error = new JSONObject();
            error.put("error", "Please login first");
            response.getWriter().write(error.toString());
            return;
        }
        
        String transactionIdParam = request.getParameter("transactionId");
        
        if (transactionIdParam == null || transactionIdParam.trim().isEmpty()) {
            JSONObject error = new JSONObject();
            error.put("error", "Order ID is required");
            response.getWriter().write(error.toString());
            return;
        }
        
        int transactionId;
        try {
            transactionId = Integer.parseInt(transactionIdParam);
        } catch (NumberFormatException e) {
            JSONObject error = new JSONObject();
            error.put("error", "Invalid order ID");
            response.getWriter().write(error.toString());
            return;
        }
        
        String query = "SELECT transaction_id, order_status, user_email, transaction_date, amount, items, cancelled FROM Transactions WHERE transaction_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, transactionId);
            ResultSet rs = pstmt.executeQuery();
            
            JSONObject json = new JSONObject();
            
            if (rs.next()) {
                String orderUserEmail = rs.getString("user_email");
                if (!userEmail.equals(orderUserEmail)) {
                    json.put("error", "You don't have permission to track this order");
                    response.getWriter().write(json.toString());
                    return;
                }
                
                String cancelled = rs.getString("cancelled");
                if ("Y".equals(cancelled)) {
                    json.put("error", "This order has been cancelled");
                    response.getWriter().write(json.toString());
                    return;
                }
                
                String dbStatus = rs.getString("order_status");
                Timestamp orderDate = rs.getTimestamp("transaction_date");
                double amount = rs.getDouble("amount");
                String items = rs.getString("items");
                
                // Calculate actual status based on time
                String orderStatus = calculateActualStatus(dbStatus, orderDate);
                boolean isDelivered = "Delivered".equals(orderStatus);
                
                // Calculate estimated delivery
                String estimatedTime = calculateEstimatedDelivery(orderStatus, orderDate, isDelivered);
                String deliveryPartner = getDeliveryPartner(orderStatus);
                String trackingNumber = "SRC" + transactionId + new SimpleDateFormat("ddMMyy").format(new Date());
                String orderDateFormatted = formatDate(orderDate);
                
                json.put("orderStatus", orderStatus);
                json.put("estimatedDelivery", estimatedTime);
                json.put("deliveryPartner", deliveryPartner);
                json.put("trackingNumber", trackingNumber);
                json.put("orderAmount", amount);
                json.put("orderItems", items != null ? items : "N/A");
                json.put("orderDate", orderDateFormatted);
                
            } else {
                json.put("error", "Order not found");
            }
            
            response.getWriter().write(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("error", "Failed to load tracking information");
            response.getWriter().write(error.toString());
        }
    }
    
    private String getDeliveryPartner(String status) {
        if ("Delivered".equals(status)) {
            return "Delivered";
        } else if ("Out for Delivery".equals(status)) {
            String[] partners = {"SRC Delivery", "FoodExpress", "QuickDeliver", "FastTrack"};
            int index = (int) (System.currentTimeMillis() % partners.length);
            return partners[index];
        } else {
            return "Waiting for assignment";
        }
    }
    
    private String formatDate(Timestamp date) {
        if (date == null) return "N/A";
        try {
            SimpleDateFormat outputFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
            return outputFormat.format(date);
        } catch (Exception e) {
            return date.toString();
        }
    }
}