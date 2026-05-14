package com.src.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import com.src.dao.DBConnection;

@WebServlet("/UpdateOrderStatusServlet")
public class UpdateOrderStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String orderId = request.getParameter("orderId");
        String status = request.getParameter("status");
        
        JSONObject json = new JSONObject();
        
        if(orderId == null || status == null) {
            json.put("success", false);
            json.put("message", "Missing parameters");
            response.getWriter().write(json.toString());
            return;
        }
        
        String query = "UPDATE Transactions SET order_status = ? WHERE transaction_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, Integer.parseInt(orderId));
            
            int updated = pstmt.executeUpdate();
            
            if(updated > 0) {
                json.put("success", true);
                json.put("message", "Status updated successfully");
            } else {
                json.put("success", false);
                json.put("message", "Order not found");
            }
            
        } catch(Exception e) {
            json.put("success", false);
            json.put("message", e.getMessage());
        }
        
        response.getWriter().write(json.toString());
    }
}