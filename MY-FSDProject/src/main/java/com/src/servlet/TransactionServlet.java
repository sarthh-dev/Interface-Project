package com.src.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
import com.src.dao.TransactionDAO;
import com.src.model.Transaction;

@WebServlet("/TransactionServlet")
public class TransactionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TransactionDAO transactionDAO = new TransactionDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if("getUserTransactions".equals(action)) {
            HttpSession session = request.getSession();
            String email = (String) session.getAttribute("userEmail");
            
            if(email != null && !email.isEmpty()) {
                List<Transaction> transactions = transactionDAO.getUserTransactions(email);
                JSONArray jsonArray = new JSONArray();
                
                for(Transaction t : transactions) {
                    JSONObject json = new JSONObject();
                    json.put("transactionId", t.getTransactionId());
                    json.put("amount", t.getAmount());
                    json.put("items", t.getItems());
                    json.put("paymentStatus", t.getPaymentStatus());
                    json.put("orderStatus", t.getOrderStatus() != null ? t.getOrderStatus() : "Processing");
                    json.put("transactionDate", t.getTransactionDate());
                    jsonArray.put(json);
                }
                response.getWriter().write(jsonArray.toString());
            } else {
                response.getWriter().write("[]");
            }
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
        
        if("saveOrder".equals(action)) {
            HttpSession session = request.getSession();
            String userEmail = (String) session.getAttribute("userEmail");
            String userName = (String) session.getAttribute("userName");
            
            if(userEmail == null || userName == null) {
                JSONObject errorJson = new JSONObject();
                errorJson.put("success", false);
                errorJson.put("error", "User not logged in");
                response.getWriter().write(errorJson.toString());
                return;
            }
            
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while((line = reader.readLine()) != null) {
                sb.append(line);
            }
            
            try {
                JSONObject json = new JSONObject(sb.toString());
                double amount = json.getDouble("amount");
                String items = json.getString("items");
                String paymentMethod = json.optString("paymentMethod", "Credit Card");
                
                // Save to database and get transaction ID
                int transactionId = saveTransactionToDatabase(userEmail, userName, amount, items, paymentMethod);
                
                JSONObject responseJson = new JSONObject();
                if(transactionId > 0) {
                    responseJson.put("success", true);
                    responseJson.put("transactionId", transactionId);
                    responseJson.put("message", "Order placed successfully");
                } else {
                    responseJson.put("success", false);
                    responseJson.put("error", "Failed to save order to database");
                }
                response.getWriter().write(responseJson.toString());
                
            } catch(Exception e) {
                e.printStackTrace();
                JSONObject errorJson = new JSONObject();
                errorJson.put("success", false);
                errorJson.put("error", e.getMessage());
                response.getWriter().write(errorJson.toString());
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid action\"}");
        }
    }
    
    private int saveTransactionToDatabase(String userEmail, String userName, double amount, String items, String paymentMethod) {
        String query = "INSERT INTO Transactions (user_email, user_name, amount, items, payment_status, order_status, transaction_date) VALUES (?, ?, ?, ?, ?, ?, SYSDATE)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, new String[]{"transaction_id"})) {
            
            pstmt.setString(1, userEmail);
            pstmt.setString(2, userName);
            pstmt.setDouble(3, amount);
            pstmt.setString(4, items);
            pstmt.setString(5, "Success");
            pstmt.setString(6, "Processing");
            
            int affectedRows = pstmt.executeUpdate();
            
            if(affectedRows > 0) {
                ResultSet generatedKeys = pstmt.getGeneratedKeys();
                if(generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
}