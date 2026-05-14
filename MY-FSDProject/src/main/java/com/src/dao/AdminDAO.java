package com.src.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDAO {
    
    public boolean loginAdmin(String email, String password) {
        String query = "SELECT * FROM AdminSignIn WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();
            
            return rs.next();
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateAdminPassword(String email, String newPassword) {
        String query = "UPDATE AdminSignIn SET password = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, newPassword);
            pstmt.setString(2, email);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}