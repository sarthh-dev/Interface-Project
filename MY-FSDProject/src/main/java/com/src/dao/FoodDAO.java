package com.src.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.src.model.Food;

public class FoodDAO {
    
    public List<Food> getAllFoodItems() {
        List<Food> foods = new ArrayList<>();
        String query = "SELECT * FROM FoodItems ORDER BY food_id";
        
        System.out.println("Fetching all food items from database...");
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                Food food = new Food();
                food.setFoodId(rs.getInt("food_id"));
                food.setName(rs.getString("name"));
                food.setCategory(rs.getString("category"));
                food.setVegNonveg(rs.getString("veg_nonveg"));
                food.setPrice(rs.getDouble("price"));
                foods.add(food);
                System.out.println("Loaded: " + food.getName() + " (ID: " + food.getFoodId() + ")");
            }
            
            System.out.println("Total food items loaded: " + foods.size());
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return foods;
    }
    
    public List<Food> getFoodsByCategory(String category) {
        List<Food> foods = new ArrayList<>();
        String query = "SELECT * FROM FoodItems WHERE category = ? ORDER BY food_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, category);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Food food = new Food();
                food.setFoodId(rs.getInt("food_id"));
                food.setName(rs.getString("name"));
                food.setCategory(rs.getString("category"));
                food.setVegNonveg(rs.getString("veg_nonveg"));
                food.setPrice(rs.getDouble("price"));
                foods.add(food);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return foods;
    }
    
    public boolean addFood(Food food) {
        String query = "INSERT INTO FoodItems (name, category, veg_nonveg, price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, food.getName());
            pstmt.setString(2, food.getCategory());
            pstmt.setString(3, food.getVegNonveg());
            pstmt.setDouble(4, food.getPrice());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateFood(Food food) {
        String query = "UPDATE FoodItems SET name = ?, category = ?, veg_nonveg = ?, price = ? WHERE food_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, food.getName());
            pstmt.setString(2, food.getCategory());
            pstmt.setString(3, food.getVegNonveg());
            pstmt.setDouble(4, food.getPrice());
            pstmt.setInt(5, food.getFoodId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteFood(int foodId) {
        String query = "DELETE FROM FoodItems WHERE food_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, foodId);
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Food getFoodById(int foodId) {
        String query = "SELECT * FROM FoodItems WHERE food_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, foodId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Food food = new Food();
                food.setFoodId(rs.getInt("food_id"));
                food.setName(rs.getString("name"));
                food.setCategory(rs.getString("category"));
                food.setVegNonveg(rs.getString("veg_nonveg"));
                food.setPrice(rs.getDouble("price"));
                return food;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public int getTotalFoodCount() {
        String query = "SELECT COUNT(*) as total FROM FoodItems";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}