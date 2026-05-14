package com.src.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;
import com.src.dao.DBConnection;

@WebServlet("/AnalyticsServlet")
public class AnalyticsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        String period = request.getParameter("period"); // weekly, monthly, yearly
        
        JSONObject result = new JSONObject();
        
        try {
            if("bestSellingItems".equals(action)) {
                result = getBestSellingItems(period);
            } else if("peakHours".equals(action)) {
                result = getPeakOrderingHours(period);
            } else if("customerSpending".equals(action)) {
                result = getCustomerSpending(period);
            } else if("monthlyReport".equals(action)) {
                result = getMonthlyReport();
            } else if("yearlyReport".equals(action)) {
                result = getYearlyReport();
            } else if("weeklyReport".equals(action)) {
                result = getWeeklyReport();
            } else if("sortTransactions".equals(action)) {
                String sortBy = request.getParameter("sortBy");
                result = getSortedTransactions(sortBy);
            }
            
            response.getWriter().write(result.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("error", e.getMessage());
            response.getWriter().write(result.toString());
        }
    }
    
    private JSONObject getBestSellingItems(String period) throws Exception {
        JSONObject result = new JSONObject();
        JSONArray items = new JSONArray();
        JSONArray counts = new JSONArray();
        JSONArray revenues = new JSONArray();
        
        String dateCondition = getDateCondition(period);
        
        String query = "SELECT items, COUNT(*) as order_count, SUM(amount) as total_revenue " +
                       "FROM Transactions WHERE payment_status = 'Success' " + dateCondition +
                       "GROUP BY items ORDER BY order_count DESC FETCH FIRST 10 ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                String itemsStr = rs.getString("items");
                String shortName = itemsStr != null && itemsStr.length() > 25 ? itemsStr.substring(0, 22) + "..." : itemsStr;
                items.put(shortName != null ? shortName : "Unknown");
                counts.put(rs.getInt("order_count"));
                revenues.put(rs.getDouble("total_revenue"));
            }
        }
        
        result.put("items", items);
        result.put("counts", counts);
        result.put("revenues", revenues);
        return result;
    }
    
    private JSONObject getPeakOrderingHours(String period) throws Exception {
        JSONObject result = new JSONObject();
        JSONArray hours = new JSONArray();
        JSONArray orderCounts = new JSONArray();
        
        String dateCondition = getDateCondition(period);
        
        String query = "SELECT TO_CHAR(transaction_date, 'HH24') as hour, COUNT(*) as order_count " +
                       "FROM Transactions WHERE payment_status = 'Success' " + dateCondition +
                       "GROUP BY TO_CHAR(transaction_date, 'HH24') ORDER BY hour";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                String hour = rs.getString("hour");
                hours.put(hour + ":00");
                orderCounts.put(rs.getInt("order_count"));
            }
        }
        
        result.put("hours", hours);
        result.put("orderCounts", orderCounts);
        return result;
    }
    
    private JSONObject getCustomerSpending(String period) throws Exception {
        JSONObject result = new JSONObject();
        JSONArray customers = new JSONArray();
        JSONArray totalSpent = new JSONArray();
        JSONArray orderCounts = new JSONArray();
        
        String dateCondition = getDateCondition(period);
        
        String query = "SELECT user_email, user_name, COUNT(*) as order_count, SUM(amount) as total_spent " +
                       "FROM Transactions WHERE payment_status = 'Success' " + dateCondition +
                       "GROUP BY user_email, user_name ORDER BY total_spent DESC FETCH FIRST 10 ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                String name = rs.getString("user_name") != null ? rs.getString("user_name") : rs.getString("user_email");
                customers.put(name);
                totalSpent.put(rs.getDouble("total_spent"));
                orderCounts.put(rs.getInt("order_count"));
            }
        }
        
        result.put("customers", customers);
        result.put("totalSpent", totalSpent);
        result.put("orderCounts", orderCounts);
        return result;
    }
    
    private JSONObject getMonthlyReport() throws Exception {
        JSONObject result = new JSONObject();
        JSONArray months = new JSONArray();
        JSONArray sales = new JSONArray();
        JSONArray orders = new JSONArray();
        
        String query = "SELECT TO_CHAR(transaction_date, 'YYYY-MM') as month, " +
                       "COUNT(*) as order_count, SUM(amount) as total_sales " +
                       "FROM Transactions WHERE payment_status = 'Success' " +
                       "GROUP BY TO_CHAR(transaction_date, 'YYYY-MM') " +
                       "ORDER BY month DESC FETCH FIRST 12 ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                months.put(rs.getString("month"));
                sales.put(rs.getDouble("total_sales"));
                orders.put(rs.getInt("order_count"));
            }
        }
        
        result.put("months", months);
        result.put("sales", sales);
        result.put("orders", orders);
        return result;
    }
    
    private JSONObject getYearlyReport() throws Exception {
        JSONObject result = new JSONObject();
        JSONArray years = new JSONArray();
        JSONArray sales = new JSONArray();
        JSONArray orders = new JSONArray();
        
        String query = "SELECT TO_CHAR(transaction_date, 'YYYY') as year, " +
                       "COUNT(*) as order_count, SUM(amount) as total_sales " +
                       "FROM Transactions WHERE payment_status = 'Success' " +
                       "GROUP BY TO_CHAR(transaction_date, 'YYYY') ORDER BY year DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                years.put(rs.getString("year"));
                sales.put(rs.getDouble("total_sales"));
                orders.put(rs.getInt("order_count"));
            }
        }
        
        result.put("years", years);
        result.put("sales", sales);
        result.put("orders", orders);
        return result;
    }
    
    private JSONObject getWeeklyReport() throws Exception {
        JSONObject result = new JSONObject();
        JSONArray weeks = new JSONArray();
        JSONArray sales = new JSONArray();
        JSONArray orders = new JSONArray();
        
        String query = "SELECT TO_CHAR(transaction_date, 'YYYY-WW') as week, " +
                       "COUNT(*) as order_count, SUM(amount) as total_sales " +
                       "FROM Transactions WHERE payment_status = 'Success' " +
                       "GROUP BY TO_CHAR(transaction_date, 'YYYY-WW') " +
                       "ORDER BY week DESC FETCH FIRST 12 ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                weeks.put(rs.getString("week"));
                sales.put(rs.getDouble("total_sales"));
                orders.put(rs.getInt("order_count"));
            }
        }
        
        result.put("weeks", weeks);
        result.put("sales", sales);
        result.put("orders", orders);
        return result;
    }
    
    private JSONObject getSortedTransactions(String sortBy) throws Exception {
        JSONObject result = new JSONObject();
        JSONArray transactions = new JSONArray();
        
        String dateCondition = "";
        String groupBy = "";
        
        if("weekly".equals(sortBy)) {
            dateCondition = "AND transaction_date >= SYSDATE - 7";
            groupBy = "TO_CHAR(transaction_date, 'YYYY-MM-DD')";
        } else if("monthly".equals(sortBy)) {
            dateCondition = "AND transaction_date >= SYSDATE - 30";
            groupBy = "TO_CHAR(transaction_date, 'YYYY-MM-DD')";
        } else if("yearly".equals(sortBy)) {
            dateCondition = "AND transaction_date >= SYSDATE - 365";
            groupBy = "TO_CHAR(transaction_date, 'YYYY-MM')";
        } else {
            groupBy = "TO_CHAR(transaction_date, 'YYYY-MM-DD')";
        }
        
        String query = "SELECT transaction_id, user_name, user_email, amount, items, payment_status, order_status, transaction_date " +
                       "FROM Transactions WHERE payment_status = 'Success' " + dateCondition +
                       "ORDER BY transaction_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
            
            while (rs.next()) {
                JSONObject trans = new JSONObject();
                trans.put("transactionId", rs.getInt("transaction_id"));
                trans.put("userName", rs.getString("user_name") != null ? rs.getString("user_name") : "Guest");
                trans.put("userEmail", rs.getString("user_email"));
                trans.put("amount", rs.getDouble("amount"));
                trans.put("items", rs.getString("items") != null ? rs.getString("items") : "-");
                trans.put("paymentStatus", rs.getString("payment_status"));
                trans.put("orderStatus", rs.getString("order_status") != null ? rs.getString("order_status") : "Processing");
                trans.put("transactionDate", rs.getTimestamp("transaction_date") != null ? sdf.format(rs.getTimestamp("transaction_date")) : "N/A");
                transactions.put(trans);
            }
        }
        
        result.put("transactions", transactions);
        result.put("count", transactions.length());
        return result;
    }
    
    private String getDateCondition(String period) {
        if("weekly".equals(period)) {
            return "AND transaction_date >= SYSDATE - 7";
        } else if("monthly".equals(period)) {
            return "AND transaction_date >= SYSDATE - 30";
        } else if("yearly".equals(period)) {
            return "AND transaction_date >= SYSDATE - 365";
        }
        return "";
    }
}