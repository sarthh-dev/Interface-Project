package com.src.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;
import com.src.dao.DBConnection;

@WebServlet("/AdminReviewServlet")
public class AdminReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Get all reviews for admin
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Check if admin is logged in
        if (request.getSession().getAttribute("adminEmail") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("[]");
            return;
        }
        
        String query = "SELECT r.review_id, r.user_email, r.user_name, r.rating, r.review_text, " +
                       "TO_CHAR(r.review_date, 'YYYY-MM-DD HH24:MI:SS') as review_date, " +
                       "r.status, f.name as food_name, f.food_id " +
                       "FROM Reviews r LEFT JOIN FoodItems f ON r.food_id = f.food_id " +
                       "ORDER BY r.review_date DESC";
        
        List<JSONObject> reviews = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                JSONObject review = new JSONObject();
                review.put("reviewId", rs.getInt("review_id"));
                review.put("userEmail", rs.getString("user_email"));
                review.put("userName", rs.getString("user_name") != null ? rs.getString("user_name") : "Anonymous");
                review.put("rating", rs.getInt("rating"));
                review.put("reviewText", rs.getString("review_text") != null ? rs.getString("review_text") : "");
                review.put("reviewDate", rs.getString("review_date"));
                review.put("status", rs.getString("status") != null ? rs.getString("status") : "active");
                review.put("foodName", rs.getString("food_name") != null ? rs.getString("food_name") : "Unknown Item");
                review.put("foodId", rs.getInt("food_id"));
                reviews.add(review);
            }
            
            response.getWriter().write(new JSONArray(reviews).toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }
    
    // Delete a review
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Check if admin is logged in
        if (request.getSession().getAttribute("adminEmail") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false,\"message\":\"Unauthorized\"}");
            return;
        }
        
        String reviewIdParam = request.getParameter("reviewId");
        
        if (reviewIdParam == null || reviewIdParam.isEmpty()) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Review ID is required");
            response.getWriter().write(error.toString());
            return;
        }
        
        int reviewId = Integer.parseInt(reviewIdParam);
        
        // Delete the review
        String deleteQuery = "DELETE FROM Reviews WHERE review_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(deleteQuery)) {
            
            pstmt.setInt(1, reviewId);
            int result = pstmt.executeUpdate();
            
            JSONObject json = new JSONObject();
            if (result > 0) {
                json.put("success", true);
                json.put("message", "Review deleted successfully");
            } else {
                json.put("success", false);
                json.put("message", "Review not found");
            }
            response.getWriter().write(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Database error: " + e.getMessage());
            response.getWriter().write(error.toString());
        }
    }
}