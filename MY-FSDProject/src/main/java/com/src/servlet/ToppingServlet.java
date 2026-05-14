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

@WebServlet("/ToppingServlet")
public class ToppingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if("getToppings".equals(action)) {
            getAllToppings(response);
        } else {
            getAllToppings(response);
        }
    }
    
    private void getAllToppings(HttpServletResponse response) throws IOException {
        String query = "SELECT topping_id, name, price, is_veg FROM Toppings WHERE status = 'active' ORDER BY name";
        List<JSONObject> toppings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                JSONObject topping = new JSONObject();
                topping.put("id", rs.getInt("topping_id"));
                topping.put("name", rs.getString("name"));
                topping.put("price", rs.getDouble("price"));
                topping.put("isVeg", rs.getString("is_veg"));
                toppings.add(topping);
            }
            
            response.getWriter().write(new JSONArray(toppings).toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }
}