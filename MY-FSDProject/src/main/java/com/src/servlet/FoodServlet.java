package com.src.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;
import com.src.dao.FoodDAO;
import com.src.model.Food;

@WebServlet("/FoodServlet")
public class FoodServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FoodDAO foodDAO = new FoodDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if("list".equals(action)) {
            List<Food> foods = foodDAO.getAllFoodItems();
            JSONArray jsonArray = new JSONArray();
            
            for(Food food : foods) {
                JSONObject json = new JSONObject();
                json.put("foodId", food.getFoodId());
                json.put("name", food.getName());
                json.put("category", food.getCategory());
                json.put("vegNonveg", food.getVegNonveg());
                json.put("price", food.getPrice());
                jsonArray.put(json);
            }
            
            response.getWriter().write(jsonArray.toString());
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid action\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if("add".equals(action)) {
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while((line = reader.readLine()) != null) {
                sb.append(line);
            }
            
            try {
                JSONObject json = new JSONObject(sb.toString());
                Food food = new Food();
                food.setName(json.getString("name"));
                food.setCategory(json.getString("category"));
                food.setVegNonveg(json.getString("vegNonveg"));
                food.setPrice(json.getDouble("price"));
                
                JSONObject responseJson = new JSONObject();
                if(foodDAO.addFood(food)) {
                    responseJson.put("message", "Food added successfully");
                    responseJson.put("success", true);
                } else {
                    responseJson.put("error", "Failed to add food");
                    responseJson.put("success", false);
                }
                response.getWriter().write(responseJson.toString());
                
            } catch(Exception e) {
                e.printStackTrace();
                JSONObject errorJson = new JSONObject();
                errorJson.put("error", "Invalid request data");
                errorJson.put("success", false);
                response.getWriter().write(errorJson.toString());
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid action\"}");
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if(idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                JSONObject responseJson = new JSONObject();
                
                if(foodDAO.deleteFood(id)) {
                    responseJson.put("message", "Food deleted successfully");
                    responseJson.put("success", true);
                } else {
                    responseJson.put("error", "Failed to delete food");
                    responseJson.put("success", false);
                }
                response.getWriter().write(responseJson.toString());
                
            } catch(NumberFormatException e) {
                JSONObject errorJson = new JSONObject();
                errorJson.put("error", "Invalid ID format");
                errorJson.put("success", false);
                response.getWriter().write(errorJson.toString());
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Food ID is required\"}");
        }
    }
}