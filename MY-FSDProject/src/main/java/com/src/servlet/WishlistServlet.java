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

@WebServlet("/WishlistServlet")
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        System.out.println("Wishlist GET called - User Email: " + userEmail);
        
        if(userEmail == null || userEmail.isEmpty()) {
            response.getWriter().write("[]");
            return;
        }
        
        // Query to get wishlist items with food details
        String query = "SELECT w.food_id, f.name, f.price, f.category, f.veg_nonveg " +
                       "FROM Wishlist w JOIN FoodItems f ON w.food_id = f.food_id " +
                       "WHERE w.user_email = ? ORDER BY w.added_date DESC";
        
        List<JSONObject> wishlist = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, userEmail);
            ResultSet rs = pstmt.executeQuery();
            
            while(rs.next()) {
                JSONObject item = new JSONObject();
                item.put("foodId", rs.getInt("food_id"));
                item.put("name", rs.getString("name"));
                item.put("price", rs.getDouble("price"));
                item.put("category", rs.getString("category"));
                item.put("vegNonveg", rs.getString("veg_nonveg"));
                wishlist.add(item);
                System.out.println("Wishlist item: " + rs.getString("name"));
            }
            
            System.out.println("Total wishlist items: " + wishlist.size());
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        response.getWriter().write(new JSONArray(wishlist).toString());
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        String action = request.getParameter("action");
        String foodIdParam = request.getParameter("foodId");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JSONObject json = new JSONObject();
        
        System.out.println("Wishlist POST called - Action: " + action + ", FoodId: " + foodIdParam + ", User: " + userEmail);
        
        if(userEmail == null || userEmail.isEmpty()) {
            json.put("success", false);
            json.put("message", "Please login first");
            response.getWriter().write(json.toString());
            return;
        }
        
        if(foodIdParam == null || foodIdParam.isEmpty()) {
            json.put("success", false);
            json.put("message", "Food ID is required");
            response.getWriter().write(json.toString());
            return;
        }
        
        int foodId = Integer.parseInt(foodIdParam);
        
        try (Connection conn = DBConnection.getConnection()) {
            if("add".equals(action)) {
                // Check if already exists
                String checkQuery = "SELECT COUNT(*) FROM Wishlist WHERE user_email = ? AND food_id = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                checkStmt.setString(1, userEmail);
                checkStmt.setInt(2, foodId);
                ResultSet rs = checkStmt.executeQuery();
                
                if(rs.next() && rs.getInt(1) > 0) {
                    json.put("success", false);
                    json.put("message", "Item already in wishlist");
                } else {
                    String insertQuery = "INSERT INTO Wishlist (user_email, food_id) VALUES (?, ?)";
                    PreparedStatement pstmt = conn.prepareStatement(insertQuery);
                    pstmt.setString(1, userEmail);
                    pstmt.setInt(2, foodId);
                    pstmt.executeUpdate();
                    json.put("success", true);
                    json.put("message", "Added to wishlist");
                    System.out.println("Added to wishlist: " + foodId);
                }
                checkStmt.close();
                
            } else if("remove".equals(action)) {
                String deleteQuery = "DELETE FROM Wishlist WHERE user_email = ? AND food_id = ?";
                PreparedStatement pstmt = conn.prepareStatement(deleteQuery);
                pstmt.setString(1, userEmail);
                pstmt.setInt(2, foodId);
                int deleted = pstmt.executeUpdate();
                json.put("success", true);
                json.put("message", "Removed from wishlist");
                System.out.println("Removed from wishlist: " + foodId + " (Deleted: " + deleted + ")");
                pstmt.close();
            } else {
                json.put("success", false);
                json.put("message", "Invalid action");
            }
        } catch(Exception e) {
            e.printStackTrace();
            json.put("success", false);
            json.put("message", e.getMessage());
        }
        
        response.getWriter().write(json.toString());
    }
}