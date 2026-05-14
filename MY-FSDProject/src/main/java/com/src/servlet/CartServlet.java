package com.src.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        
        if(cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }
        
        if("add".equals(action)) {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            int quantity = cart.getOrDefault(foodId, 0) + 1;
            cart.put(foodId, quantity);
            
            JSONObject json = new JSONObject();
            json.put("success", true);
            json.put("message", "Item added to cart");
            response.getWriter().write(json.toString());
        }
    }
}