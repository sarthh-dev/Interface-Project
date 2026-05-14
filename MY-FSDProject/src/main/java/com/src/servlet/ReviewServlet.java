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
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;
import com.src.dao.DBConnection;

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Get reviews for a specific food item
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String foodId = request.getParameter("foodId");
        
        if (foodId == null || foodId.isEmpty()) {
            response.getWriter().write("[]");
            return;
        }
        
        String query = "SELECT review_id, user_name, rating, review_text, TO_CHAR(review_date, 'YYYY-MM-DD HH24:MI:SS') as review_date " +
                       "FROM Reviews WHERE food_id = ? AND status = 'active' ORDER BY review_date DESC";
        
        List<JSONObject> reviews = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, Integer.parseInt(foodId));
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                JSONObject review = new JSONObject();
                review.put("reviewId", rs.getInt("review_id"));
                review.put("userName", rs.getString("user_name") != null ? rs.getString("user_name") : "Anonymous");
                review.put("rating", rs.getInt("rating"));
                review.put("reviewText", rs.getString("review_text") != null ? rs.getString("review_text") : "");
                review.put("reviewDate", rs.getString("review_date"));
                reviews.add(review);
            }
            
            response.getWriter().write(new JSONArray(reviews).toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }
    
    // Submit a new review
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        String userName = (String) session.getAttribute("userName");
        
        JSONObject json = new JSONObject();
        
        // Check if user is logged in
        if (userEmail == null) {
            json.put("success", false);
            json.put("message", "Please login to submit a review");
            response.getWriter().write(json.toString());
            return;
        }
        
        String foodIdParam = request.getParameter("foodId");
        String ratingParam = request.getParameter("rating");
        String reviewText = request.getParameter("reviewText");
        
        // Validate inputs
        if (foodIdParam == null || foodIdParam.isEmpty()) {
            json.put("success", false);
            json.put("message", "Food ID is required");
            response.getWriter().write(json.toString());
            return;
        }
        
        if (ratingParam == null || ratingParam.isEmpty()) {
            json.put("success", false);
            json.put("message", "Please select a rating");
            response.getWriter().write(json.toString());
            return;
        }
        
        int foodId = Integer.parseInt(foodIdParam);
        int rating = Integer.parseInt(ratingParam);
        
        if (rating < 1 || rating > 5) {
            json.put("success", false);
            json.put("message", "Rating must be between 1 and 5");
            response.getWriter().write(json.toString());
            return;
        }
        
        if (reviewText == null || reviewText.trim().isEmpty()) {
            json.put("success", false);
            json.put("message", "Please write a review");
            response.getWriter().write(json.toString());
            return;
        }
        
        if (reviewText.length() < 5) {
            json.put("success", false);
            json.put("message", "Review must be at least 5 characters");
            response.getWriter().write(json.toString());
            return;
        }
        
        // Check if user already reviewed this item
        String checkQuery = "SELECT COUNT(*) FROM Reviews WHERE user_email = ? AND food_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
            
            checkStmt.setString(1, userEmail);
            checkStmt.setInt(2, foodId);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                json.put("success", false);
                json.put("message", "You have already reviewed this item!");
                response.getWriter().write(json.toString());
                return;
            }
            
            // Insert new review
            String insertQuery = "INSERT INTO Reviews (user_email, user_name, food_id, rating, review_text, review_date) VALUES (?, ?, ?, ?, ?, SYSDATE)";
            
            try (PreparedStatement pstmt = conn.prepareStatement(insertQuery)) {
                pstmt.setString(1, userEmail);
                pstmt.setString(2, userName != null ? userName : userEmail);
                pstmt.setInt(3, foodId);
                pstmt.setInt(4, rating);
                pstmt.setString(5, reviewText.trim());
                
                int result = pstmt.executeUpdate();
                
                if (result > 0) {
                    json.put("success", true);
                    json.put("message", "Thank you for your review! ⭐");
                } else {
                    json.put("success", false);
                    json.put("message", "Failed to submit review");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            json.put("success", false);
            json.put("message", "Database error: " + e.getMessage());
        }
        
        response.getWriter().write(json.toString());
    }
}