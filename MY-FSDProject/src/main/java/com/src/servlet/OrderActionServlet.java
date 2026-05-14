package com.src.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;
import com.src.dao.DBConnection;

@WebServlet("/OrderActionServlet")
public class OrderActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        
        if (userEmail == null) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Please login first");
            response.getWriter().write(error.toString());
            return;
        }
        
        String action = request.getParameter("action");
        String transactionIdParam = request.getParameter("transactionId");
        
        if (transactionIdParam == null || transactionIdParam.trim().isEmpty()) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Order ID is required");
            response.getWriter().write(error.toString());
            return;
        }
        
        int transactionId;
        try {
            transactionId = Integer.parseInt(transactionIdParam);
        } catch (NumberFormatException e) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Invalid order ID");
            response.getWriter().write(error.toString());
            return;
        }
        
        // Verify order belongs to user
        String verifyQuery = "SELECT order_status, cancelled, items FROM Transactions WHERE transaction_id = ? AND user_email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement verifyStmt = conn.prepareStatement(verifyQuery)) {
            
            verifyStmt.setInt(1, transactionId);
            verifyStmt.setString(2, userEmail);
            ResultSet rs = verifyStmt.executeQuery();
            
            if (!rs.next()) {
                JSONObject error = new JSONObject();
                error.put("success", false);
                error.put("message", "Order not found");
                response.getWriter().write(error.toString());
                return;
            }
            
            String orderStatus = rs.getString("order_status");
            String cancelled = rs.getString("cancelled");
            String items = rs.getString("items");
            
            if ("Y".equals(cancelled)) {
                JSONObject error = new JSONObject();
                error.put("success", false);
                error.put("message", "Order is already cancelled");
                response.getWriter().write(error.toString());
                return;
            }
            
            if ("cancel".equals(action)) {
                // Can only cancel if not delivered
                if ("Delivered".equals(orderStatus)) {
                    JSONObject error = new JSONObject();
                    error.put("success", false);
                    error.put("message", "Cannot cancel delivered order");
                    response.getWriter().write(error.toString());
                    return;
                }
                
                String cancelQuery = "UPDATE Transactions SET cancelled = 'Y', cancelled_date = SYSDATE, order_status = 'Cancelled' WHERE transaction_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(cancelQuery)) {
                    pstmt.setInt(1, transactionId);
                    int updated = pstmt.executeUpdate();
                    
                    JSONObject result = new JSONObject();
                    if (updated > 0) {
                        result.put("success", true);
                        result.put("message", "Order cancelled successfully");
                    } else {
                        result.put("success", false);
                        result.put("message", "Failed to cancel order");
                    }
                    response.getWriter().write(result.toString());
                }
                
            } else if ("reorder".equals(action)) {
                // Return the items to reorder
                JSONObject result = new JSONObject();
                result.put("success", true);
                result.put("message", "Items added to cart");
                result.put("items", items != null ? items : "");
                response.getWriter().write(result.toString());
            } else {
                JSONObject error = new JSONObject();
                error.put("success", false);
                error.put("message", "Invalid action");
                response.getWriter().write(error.toString());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Database error: " + e.getMessage());
            response.getWriter().write(error.toString());
        }
    }
}